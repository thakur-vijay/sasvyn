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
                return .run { [client] send in
                    try await withThrowingTaskGroup(of: Void.self) { group in
                        for mockup in mockups {
                            group.addTask {
                                guard let newData = await Exporter.renderMockup(
                                    imageData: mockup.imageData,
                                    scaleResize: mockup.imageResize,
                                    device: mockup.device,
                                    quality: .fourK
                                ) else {
                                    return
                                }

                                let id = UUID().uuidString

                                let mockupURL = try MockupStorage.mockupURL(for: id)
                                try newData.write(to: mockupURL)

                                // Generate thumbnail
                                guard let thumbnailData = Exporter.downsample(
                                    imageData: newData,
                                    maxPixelSize: 512
                                ) else {
                                    return
                                }

                                let thumbnailURL = try MockupStorage.thumbnailURL(for: id)
                                try thumbnailData.write(to: thumbnailURL)

                                let values = try mockupURL.resourceValues(
                                    forKeys: [
                                        .fileSizeKey,
                                        .contentModificationDateKey
                                    ]
                                )
                                let aspectRatio = (mockup.device.uiImage?.size.width ?? 0) / (mockup.device.uiImage?.size.height ?? 0)
                                let mockupModel = MockupModel(
                                    id: id,
                                    url: mockupURL,
                                    thumbnail: thumbnailURL,
                                    size: Int64(values.fileSize ?? 0),
                                    device: mockup.device.assetName,
                                    aspectRatio: aspectRatio,
                                    createdAt: .now,
                                    updatedAt: .now
                                )

                                try await client.add(mockupModel)

                                let image = MockupImageMapper.map(mockupModel)

                                await send(.mockupModelAdded(image))
                            }
                        }

                        try await group.waitForAll()
                    }
                    await send(.exportFinished)
                }
            case .mockupModelAdded(let mockup):
                return .send(.delegate(.addMockup(mockup)))
            case .delegate(_):
                return .none
            case .exportFinished:
                state.isDismissRequested = true
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
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension iOSCreateMockupFeature.Destination.State: Equatable {}
