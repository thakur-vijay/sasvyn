//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 16/08/26.
//

import ComposableArchitecture
import PhotosUI
import _PhotosUI_SwiftUI
import SVProjectKit
import SVFoundation

@Reducer
public struct AppInfoFeature {
    
    @ObservableState
    public struct State: Equatable {
        public var name: String = ""
        public var tagline: String = ""
        public var category: AppCategory? = nil
        public var appIconURL: URL? = nil
        public var mode: ProjectMode
        
        var selectedAppIcon: PhotosPickerItem?
        var isAppCategoryPickerPresented: Bool = false
    
        public init(mode: ProjectMode){
            self.mode = mode
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case modeChanged(ProjectMode)
        case selectedAppIconChanged(PhotosPickerItem?)
        case appIconValidationResult(URL?)
        case setData(
            _ name: String,
            _ tagline: String,
            _ category: AppCategory?,
            _ appIconURL: URL?
        )
        case updateAppIcon(URL?)
        case infoChanged
        case delegate(Delegate)
        
        public enum Delegate {
            case infoChanged
        }
    }
    
    public init(){
        
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .modeChanged(let mode):
                state.mode = mode
                return .none
            case .binding(_):
                return .none
            case .selectedAppIconChanged(let item):
                guard let item else {
                    state.appIconURL = nil
                    return .none
                }
                return .run { send in
                    let validatedItem = await AppIconValidator.validate(item)
                    await send(.appIconValidationResult(validatedItem))
                }
            case .appIconValidationResult(let item):
                state.appIconURL = item
                return .send(.infoChanged)
            case .setData(let name, let tagline, let category, let appIconURL):
                state.name = name
                state.tagline = tagline
                state.category = category
                state.appIconURL = appIconURL
                return .none
            case .infoChanged:
                return .send(.delegate(.infoChanged))
            case .delegate(_):
                return .none
            case .updateAppIcon(let appIcon):
                guard let appIcon else { return .none }
                state.appIconURL = appIcon
                return .none
            }
        }
    }
}


enum AppIconValidator {

    static func validate(
        _ item: PhotosPickerItem,
    ) async -> URL? {

        do {
            guard let data = try await item.loadTransferable(
                type: Data.self
            ) else {
                print("❌ App Icon Error: Unable to load image.")
                return nil
            }

//            guard let image = UIImage(data: data),
//                  let cgImage = image.cgImage else {
//                print("❌ App Icon Error: Invalid image data.")
//                return nil
//            }
//
//            let width = cgImage.width
//            let height = cgImage.height
//
//            guard width == height else {
//                print(
//                    "❌ App Icon Error: Image must be square. Got \(width)x\(height)"
//                )
//                return nil
//            }
//
//            guard width == 1024 else {
//                print(
//                    "❌ App Icon Error: Image must be exactly 1024x1024. Got \(width)x\(height)"
//                )
//                return nil
//            }

            let temporaryURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(
                    UUID().uuidString,
                    isDirectory: false
                )
                .appendingPathExtension("png")
            
            try data.write(to: temporaryURL)
            return temporaryURL

        } catch {
            print("❌ App Icon Error:", error)
            return nil
        }
    }
}

internal extension AppInfoFeature.State {
    var isDetailsReady: Bool {
        return (appIconURL != nil) && name.isNotEmpty && tagline.isNotEmpty && (category != nil)
    }
    
    func update(into project: inout Project)-> URL?{
        do {
            project.name = name
            project.tagline = tagline
            project.category = category

            guard let temporaryURL = appIconURL else {
                return nil
            }
            
            if let currentIconURL = project.icon,
                currentIconURL.standardizedFileURL == temporaryURL.standardizedFileURL {
                print("app icon not changed")
                return nil
            }
            
            let permanentURL = try ProjectStorage.appIconURL(
                projectID: project.id
            )
            
            try FileStorage.replaceItem(
                at: temporaryURL,
                with: permanentURL
            )

            project.icon = permanentURL
            return permanentURL
        }catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
