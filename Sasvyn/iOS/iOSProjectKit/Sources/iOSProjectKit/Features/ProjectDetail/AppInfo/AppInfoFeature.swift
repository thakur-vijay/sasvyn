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
        public let projectID: String
        public var name: String
        public var tagline: String
        public var category: AppCategory?
        public var appIconURL: URL?
        public var mode: ProjectMode
        
        var selectedAppIcon: PhotosPickerItem?
        var isAppCategoryPickerPresented: Bool = false
    
        public init(
            mode: ProjectMode,
            projectID: String,
            name: String,
            tagline: String,
            category: AppCategory?,
            appIconURL: URL?
        ){
            self.projectID = projectID
            self.mode = mode
            self.name = name
            self.tagline = tagline
            self.category = category
            self.appIconURL = appIconURL
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case modeChanged(ProjectMode)
        case selectedAppIconChanged(PhotosPickerItem?)
        case appIconValidationResult(URL?)
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
                let projectID = state.projectID
                return .run { send in
                    let validatedItem = await AppIconValidator.validate(item, projectID: projectID)
                    await send(.appIconValidationResult(validatedItem))
                }
            case .appIconValidationResult(let item):
                state.appIconURL = item
                return .none
            }
        }
    }
}


enum AppIconValidator {

    static func validate(
        _ item: PhotosPickerItem,
        projectID: String
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
    
    func update(into project: inout Project) {
        project.name = name
        project.tagline = tagline
        project.category = category

        guard let temporaryURL = appIconURL else {
            return
        }
        
        if let currentIconURL = project.icon,
            currentIconURL.standardizedFileURL == temporaryURL.standardizedFileURL {
            print("app icon not changed")
            return
        }
        
        guard let permanentURL = try? ProjectStorage.appIconURL(
            projectID: project.id
        ) else { return }

        try? FileStorage.replaceItem(
            at: temporaryURL,
            with: permanentURL
        )

        project.icon = permanentURL
    }
}
