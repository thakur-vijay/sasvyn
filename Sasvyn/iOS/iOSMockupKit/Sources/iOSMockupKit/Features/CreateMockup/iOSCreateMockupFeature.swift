//
//  File.swift
//  iOSMockupKit
//
//  Created by Vijay Thakur on 23/08/26.
//

import ComposableArchitecture
import SVMockupKit
import _PhotosUI_SwiftUI

@Reducer
public struct iOSCreateMockupFeature {
    
    @Dependency(\.mockupsClient)
    private var client
    
    @ObservableState
    public struct State: Equatable {
        public var mockups: [Mockup] = []
        public var selectedMockup: Mockup? = nil
        public var selectedDevice: Device? = Devices.all.first { $0.screen.isNotEmpty }
        public var selectedItems: [PhotosPickerItem] = []
        public var exportType: ExportQuality = .hd
        public var selectedItem: PhotosPickerItem?
        public var isMockupPhotoPickerPresented: Bool = false
        public var isDismissRequested = false
        public var isExporting = false
        public var isExportCancelled = false
        public var exportProgress: CGFloat = 0
        public var exportCount: Int = 0
        public init(){
        }
        
        @Presents
        public var destination: Destination.State?
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case changeDeviceTapped
        case newItemsAdded([PhotosPickerItem])
        case onMockupPhotoItemChange(PhotosPickerItem?)
        case updatedImageDataForSelectedMockup(Data)
        case selectedMockupTapped
        case mockupsReady([Mockup])
        case mockupTapped(Mockup)
        case exportTapped
        case mockupModelAdded(MockupImage)
        case exportFinished
        case closeTapped
        case resizeTapped
        case applyToAllTapped
        case qualityTapped(ExportQuality)
        case delegate(Delegate)
        case onItemProvidersLoaded([Data])
        case cancelExportTapped
        
        public enum Delegate {
            case addMockup(MockupImage)
            case exportFinished
            case close
        }
    }
    
    @Reducer
    public enum Destination {
        case devicePicker(iOSDevicePickerFeature)
    }
    
    public init(){
        
    }
    
    private enum CancelID {
        case export
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce {
            state,
            action in
            switch action {
            case .binding(_):
                return .none
            case .destination(.presented(.devicePicker(.delegate(.deviceSelected(let device))))):
                if state.selectedMockup == nil {
                    state.selectedDevice = device
                }else {
                    if let index = state.mockups.firstIndex(where: { $0.id == state.selectedMockup?.id }){
                        state.mockups[index].device = device
                        state.selectedMockup = state.mockups[index]
                    }
                }
                state.destination = nil
                return .none
            case .destination(.presented(.devicePicker(.delegate(.close)))):
                state.destination = nil
                return .none
            case .destination:
                return .none
            case .changeDeviceTapped:
                state.destination = .devicePicker(.init(selectedDevice: state.selectedDevice))
                return .none
            case .newItemsAdded(let newItems):
                state.selectedItems.removeAll()
                let selectedDevice = state.selectedDevice!
                return .run { send in
                    let mockups = try await withThrowingTaskGroup(of: Mockup?.self, returning: [Mockup].self) { group in
                        for item in newItems {
                            group.addTask {
                                guard let data = try? await item.loadTransferable(type: Data.self) else {
                                    return nil
                                }
                                return Mockup(
                                    id: UUID().uuidString,
                                    device: selectedDevice,
                                    imageData: data,
                                    imageResize: .fill
                                )
                            }
                        }
                        
                        var result: [Mockup] = []
                        for try await mockup in group {
                            if let mockup {
                                result.append(mockup)
                            }
                        }
                        return result
                    }
                    
                    await send(.mockupsReady(mockups))
                }
            case .mockupsReady(let mockups):
                state.mockups.append(contentsOf: mockups)
                if state.selectedMockup == nil {
                    state.selectedMockup = state.mockups.first
                }
                return .none
            case .mockupTapped(let mockup):
                state.selectedMockup = mockup
                return .none
            case .exportTapped:
                let mockups = state.mockups
                let type = state.exportType

                state.isExporting = true
                state.isExportCancelled = false
                state.exportCount = mockups.count
 
                return .run { [client] send in
                    for mockup in mockups {
                        try Task.checkCancellation()

                        let cgImage = await MainActor.run {
                            Exporter.renderMockup(
                                imageData: mockup.imageData,
                                scaleResize: mockup.imageResize,
                                device: mockup.device,
                                quality: type
                            )
                        }

                        try Task.checkCancellation()

                        let newData: Data? = autoreleasepool {
                            guard let cgImage else {
                                return nil
                            }

                            return Exporter.encodePNG(cgImage)
                        }

                        try Task.checkCancellation()

                        guard let newData else {
                            continue
                        }

                        guard let mockupModel = try client.prepare(
                            newData,
                            mockup
                        ) else {
                            continue
                        }

                        try Task.checkCancellation()

                        try await client.add(mockupModel)

                        let image = MockupImageMapper.map(mockupModel)

                        await send(.mockupModelAdded(image))
                    }

                    await send(.exportFinished)
                }
                .cancellable(id: CancelID.export)
            case .mockupModelAdded(let mockup):
                state.mockups.removeAll { $0.id == mockup.id }
                let addedCount = state.exportCount - state.mockups.count
                state.exportProgress = CGFloat(addedCount) / CGFloat(state.exportCount)
                return .send(.delegate(.addMockup(mockup)))
            case .delegate(_):
                return .none
            case .exportFinished:
                state.isDismissRequested = true
                state.isExporting = false
                return .send(.delegate(.exportFinished))
            case .closeTapped:
                state.isDismissRequested = true
                return .send(.delegate(.close))
            case .resizeTapped:
                let next = state.selectedMockup?.imageResize.next ?? .fill
                state.selectedMockup?.imageResize = next
                return .none
            case .applyToAllTapped:
                if let selectedMockup = state.selectedMockup{
                    for index in 0..<state.mockups.count {
                        state.mockups[index].device = selectedMockup.device
                        state.mockups[index].imageResize = selectedMockup.imageResize
                    }
                }
                return .none
            case .onMockupPhotoItemChange(let newItem):
                state.selectedItem = nil
                guard let newItem else { return .none }
                return .run { send in
                    do {
                        guard let data = try await newItem.loadTransferable(type: Data.self) else { return }
                        await send(.updatedImageDataForSelectedMockup(data))
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            case .updatedImageDataForSelectedMockup(let newData):
                state.selectedMockup?.imageData = newData
                if let index = state.mockups.firstIndex(where: { $0.id == state.selectedMockup?.id }){
                    state.mockups[index].imageData = newData
                }
                return .none
            case .selectedMockupTapped:
                state.isMockupPhotoPickerPresented = true
                return .none
            case .qualityTapped(let quality):
                state.exportType = quality
                return .none
            case .onItemProvidersLoaded(let images):
                print("from feature", images.count)
                let selectedDevice = state.selectedDevice!
                return .send(
                    .mockupsReady(
                        images.map {
                            Mockup(
                                id: UUID().uuidString,
                                device: selectedDevice,
                                imageData: $0,
                                imageResize: .fill
                            )
                        }
                    )
                )
            case .cancelExportTapped:
                state.isExportCancelled = true
                state.isExporting = false
                return .cancel(id: CancelID.export)
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension iOSCreateMockupFeature.Destination.State: Equatable {}
