//
//  SwiftUIView.swift
//  iOSDocumentsKit
//
//  Created by Vijay Thakur on 15/08/26.
//

import ComposableArchitecture
import SVDocumentKit
import Foundation

@Reducer
public struct iOSDocumentsFeature {
    
    @Dependency(\.documentsClient)
    private var client
    
    @ObservableState
    public struct State: Equatable {
        public var isDocumentPickerPresented: Bool = false
        public var isDocumentCategoryPickerPresented: Bool = false
        public var selectedURL: URL?
        public var importedDocumentURL: URL?
        public var documentToDelete: Document?
        public var selectedDocumentCategory: DocumentCategory?
        public var pickedDocumentCategory: DocumentCategory?
        public var documents: [Document] = []
        public init(){}
        
        @Presents
        public var alert: AlertState<Action.Alert>?
        
        public var documentURLS: [URL]{
            documents.map(\.url)
        }
    }
    
    public enum Action: BindableAction{
        case binding(BindingAction<State>)
        case alert(PresentationAction<Alert>)
        case onTask
        case addDocumentTapped
        case documentsLoaded([Document])
        case onDocumentImport(_ result: Result<[URL], Error>)
        case documentImported(Document)
        case documentImportFailed
        case documentSaved(Document)
        case documentSaveFailed
        case deleteDocumentTapped(Document)
        case documentQuickLook(Document)
        case documentDeleted(Document)
        case documentDeleteFailed
        case documentCategorySelected(DocumentCategory?)
        case onDocumentCategoryPickerDismiss
        case addDocument(DocumentCategory)
        
        public enum Alert {
            case deleteConfirmed
        }
    }
    
    public init(){
        
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding: return .none
            case .addDocumentTapped:
                state.isDocumentPickerPresented = true
                return .none
            case .onTask:
                let category = state.selectedDocumentCategory
                return .run {[client] send in
                    let documents = try await client.fetch(category)
                    await send(.documentsLoaded(documents))
                }
            case .documentsLoaded(let documents):
                state.documents = documents
                return .none
            case .onDocumentImport(let result):
                switch result {
                case .success(let urls):
                    guard let url = urls.first else {
                        return .send(.documentImportFailed)
                    }
                    state.importedDocumentURL = url
                    if let selectedCategory = state.selectedDocumentCategory {
                        return .send(.addDocument(selectedCategory))
                    }else {
                        state.isDocumentCategoryPickerPresented = true
                        return .none
                    }
                case .failure:
                    return .send(.documentImportFailed)
                }
            case .documentImportFailed:
                return .none
            case .documentImported(let document):
                state.importedDocumentURL = nil
                state.pickedDocumentCategory = nil
                return .run {[client] send in
                    do {
                        try await client.add(document)
                        await send(.documentSaved(document))
                    }catch {
                        await send(.documentSaveFailed)
                    }
                }
            case .documentSaveFailed:
                return .none
            case .documentSaved(let document):
                state.documents.append(document)
                return .none
            case .deleteDocumentTapped(let document):
                state.documentToDelete = document
                state.alert = AlertState {
                    TextState("Delete Document?")
                } actions: {
                    ButtonState(
                        role: .destructive,
                        action: .deleteConfirmed
                    ) {
                        TextState("Delete")
                    }
                    
                    ButtonState(role: .cancel) {
                        TextState("Cancel")
                    }
                } message: {
                    TextState(
                        "Are you sure you want to delete \"\(document.name)\"?"
                    )
                }
                
                return .none
            case .alert(.presented(.deleteConfirmed)):
                guard let document = state.documentToDelete else {
                    return .none
                }

                state.documentToDelete = nil

                return .run { [client] send in
                    do {
                        try await client.delete(document.id)
                        await send(.documentDeleted(document))
                    } catch {
                        await send(.documentDeleteFailed)
                    }
                }
            case .alert(.dismiss):
                state.documentToDelete = nil
                return .none
            case .documentQuickLook(let document):
                state.selectedURL = document.url
                return .none
            case .documentDeleted(let document):
                state.documents.removeAll { $0.id == document.id }
                return .none
            case .documentDeleteFailed:
                return .none
            case .documentCategorySelected(let category):
                state.selectedDocumentCategory = category
                return .send(.onTask)
            case .onDocumentCategoryPickerDismiss:
                state.isDocumentCategoryPickerPresented = false
                state.importedDocumentURL = nil
                state.pickedDocumentCategory = nil
                return .none
            case .addDocument(let category):
                state.isDocumentCategoryPickerPresented = false
                if let url = state.importedDocumentURL {
                    return .run { [client] send in
                        do {
                            let document = try await client.import(url, category)
                            await send(.documentImported(document))
                        } catch {
                            await send(.documentImportFailed)
                        }
                    }
                }else {
                    return .send(.documentImportFailed)
                }
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
