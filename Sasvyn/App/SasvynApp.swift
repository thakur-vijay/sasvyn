//
//  SasvynApp.swift
//  Sasvyn
//
//  Created by Vijay Thakur on 31/07/26.
//

import SwiftUI
import ComposableArchitecture
import SVDIInfra
import Owlse
import OwlseProxy
#if os(iOS)
import UIKit
import iOSRootKit
#elseif os(macOS)
import AppKit
import macOSRootKit
#endif

@main
struct SasvynApp: App {
#if os(iOS)
@UIApplicationDelegateAdaptor(AppDelegate.self)
private var appDelegate
#elseif os(macOS)
@NSApplicationDelegateAdaptor(AppDelegate.self)
private var appDelegate
#endif
    
    private let appDIContainer = SVAppDIContainer()

#if os(iOS)
private let rootDIContainer: iOSRootDIContainer
#elseif os(macOS)
private let rootDIContainer: macOSRootDIContainer
#endif
    
    init() {
        NetworkLogger.enableProxy()

#if DEBUG
        // Stream logs to the Owlse desktop app: register the
        // default store with the remote logger and auto-connect
        // to the first server found on the local network.
        RemoteLogger.shared.initialize(store: .shared)
        RemoteLogger.shared.isAutomaticConnectionEnabled = true
#endif
#if os(iOS)
        self.rootDIContainer = iOSRootDIContainer(appDIContainer: appDIContainer)
#elseif os(macOS)
        self.rootDIContainer = macOSRootDIContainer(appDIContainer: appDIContainer)
#endif
        AppDelegate.rootDIContainer = self.rootDIContainer
        #if os(iOS)
        let customImage = UIImage(
            systemName: "chevron.left",
            withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)
        )?.withTintColor(.init(.accentColor), renderingMode: .alwaysOriginal)
        UINavigationBar.appearance().backIndicatorImage = customImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = customImage
        #endif
    }

    var body: some Scene {
        WindowGroup {
            self.rootDIContainer.makeView()
        }
        .defaultSize(.init(width: 1200, height: 800))
        .windowResizability(.contentMinSize)
        
    }
}

