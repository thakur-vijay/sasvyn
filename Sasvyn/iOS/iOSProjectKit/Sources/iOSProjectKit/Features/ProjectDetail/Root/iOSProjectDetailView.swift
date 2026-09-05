//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVRemoteImage
import SVDesignSystem
import Photos
import PhotosUI
import TipKit

struct AppInfoTip: Tip {
    var title: Text = Text("All info about app")
}

public struct iOSProjectDetailView: View {
    private let store: StoreOf<iOSProjectDetailFeature>
    
    public init(store: StoreOf<iOSProjectDetailFeature>) {
        self.store = store
    }
    
    let tip = AppInfoTip()
    public var body: some View {
        GeometryReader {
            let size = $0.size
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20){
                    AppInfoView(
                        store: store.scope(\.appInfo, action: \.appInfo)
                    )
                    .padding(.horizontal, SVSpacing.screenHorizontal)
                    
                    OverviewView(
                        store: store.scope(\.overview, action: \.overview)
                    )
                    .padding(.horizontal, SVSpacing.screenHorizontal)
                    
                    RoleView(
                        store: store.scope(\.role, action: \.role)
                    )
                    .padding(.horizontal, SVSpacing.screenHorizontal)
                        
                    TechStackView(
                        store: store.scope(\.techStack, action: \.techStack)
                    )
                    .padding(.horizontal, SVSpacing.screenHorizontal)
                    ScreenshotsView(
                        screenSize: size,
                        store: store.scope(\.screenshots, action: \.screenshots)
                    )
                    DescriptionView(
                        store: store.scope(
                            \.appDescription,
                             action: \.appDescription
                        )
                    )
                    .padding(.horizontal, SVSpacing.screenHorizontal)
                }
                .padding(.vertical, SVSpacing.screenVertical)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .animation(.smooth, value: store.mode)
        .toolbar {
            if store.viewMode == .sheet {
                SVToolbarItem.close {
                    store.send(.closeTapped)
                }
            }
            if store.mode == .create {
                SVToolbarItem.check(store.isProjectReadyToAdd){
                    store.send(.saveTapped)
                }
            } else {
                SVToolbarItem(
                    symbol: store.mode == .edit ? SVSymbols.close : SVSymbols.edit,
                    placement: .topBarTrailing
                ) {
                    store.send(.toggleModeTapped)
                }
            }
        }
        .task {
            await store.send(.onTask).finish()
        }
        .isASheet(store.viewMode == .sheet)
    }
}
