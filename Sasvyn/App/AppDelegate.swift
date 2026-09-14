//
//  AppDelegate.swift
//  Sasvyn
//
//  Created by Vijay Thakur on 05/09/26.
//

#if os(iOS)

import UIKit
import SVDIInfra
import CoreSpotlight
import iOSRootKit

final class AppDelegate: NSObject, UIApplicationDelegate {

    static var rootDIContainer: iOSRootDIContainer?

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {

        let configuration = UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )

        configuration.delegateClass = SceneDelegate.self
        return configuration
    }
}

#elseif os(macOS)

import AppKit
import SVDIInfra
import CoreSpotlight
import macOSRootKit

final class AppDelegate: NSObject, NSApplicationDelegate {

    static var rootDIContainer: macOSRootDIContainer?
}

#endif
