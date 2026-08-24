//
//  DeviceMockup.swift
//  SVMockupKit
//
//  Created by Vijay Thakur on 23/08/26.
//

import Foundation
import UIKit

public struct Device: Identifiable, Hashable, Sendable {
    public let id: String
    public let generation: String
    public let variant: String
    public let finish: String
    public let assetName: String
    public let screenSize: CGSize
    
    public init(
        id: String,
        generation: String,
        variant: String,
        finish: String,
        assetName: String,
        screenSize: CGSize
    ) {
        self.id = id
        self.generation = generation
        self.variant = variant
        self.finish = finish
        self.assetName = assetName
        self.screenSize = screenSize
    }
    
    public var uiImage: UIImage? {
        .init(named: assetName, in: .module, with: .none)
    }
}

public enum Devices {
    
    public static let all: [Device] = [
        Device(
            id: "iphone-17-black",
            generation: "iPhone 17",
            variant: "Standard",
            finish: "Black",
            assetName: "iPhone 17 - Black - Portrait",
            screenSize: .init(width: 1206, height: 2622)
        ),
        Device(
            id: "iphone-17-lavender",
            generation: "iPhone 17",
            variant: "Standard",
            finish: "Lavender",
            assetName: "iPhone 17 - Lavender - Portrait",
            screenSize: .init(width: 1206, height: 2622)
        ),
        Device(
            id: "iphone-17-mist-blue",
            generation: "iPhone 17",
            variant: "Standard",
            finish: "Mist Blue",
            assetName: "iPhone 17 - Mist Blue - Portrait",
            screenSize: .init(width: 1206, height: 2622)
        ),
        Device(
            id: "iphone-17-sage",
            generation: "iPhone 17",
            variant: "Standard",
            finish: "Sage",
            assetName: "iPhone 17 - Sage - Portrait",
            screenSize: .init(width: 1206, height: 2622)
        ),
        Device(
            id: "iphone-17-white",
            generation: "iPhone 17",
            variant: "Standard",
            finish: "White",
            assetName: "iPhone 17 - White - Portrait",
            screenSize: .init(width: 1206, height: 2622)
        ),

        Device(
            id: "iphone-17-pro-cosmic-orange",
            generation: "iPhone 17",
            variant: "Pro",
            finish: "Cosmic Orange",
            assetName: "iPhone 17 Pro - Cosmic Orange - Portrait",
            screenSize: .init(width: 1206, height: 2622)
        ),
        Device(
            id: "iphone-17-pro-deep-blue",
            generation: "iPhone 17",
            variant: "Pro",
            finish: "Deep Blue",
            assetName: "iPhone 17 Pro - Deep Blue - Portrait",
            screenSize: .init(width: 1206, height: 2622)
        ),
        Device(
            id: "iphone-17-pro-silver",
            generation: "iPhone 17",
            variant: "Pro",
            finish: "Silver",
            assetName: "iPhone 17 Pro - Silver - Portrait",
            screenSize: .init(width: 1206, height: 2622)
        ),

        Device(
            id: "iphone-17-pro-max-cosmic-orange",
            generation: "iPhone 17",
            variant: "Pro Max",
            finish: "Cosmic Orange",
            assetName: "iPhone 17 Pro Max - Cosmic Orange - Portrait",
            screenSize: .init(width: 1320, height: 2868)
        ),
        Device(
            id: "iphone-17-pro-max-deep-blue",
            generation: "iPhone 17",
            variant: "Pro Max",
            finish: "Deep Blue",
            assetName: "iPhone 17 Pro Max - Deep Blue - Portrait",
            screenSize: .init(width: 1320, height: 2868)
        ),
        Device(
            id: "iphone-17-pro-max-silver",
            generation: "iPhone 17",
            variant: "Pro Max",
            finish: "Silver",
            assetName: "iPhone 17 Pro Max - Silver - Portrait",
            screenSize: .init(width: 1320, height: 2868)
        ),
        Device(
            id: "iphone-air-cloud-white",
            generation: "iPhone Air",
            variant: "Air",
            finish: "Cloud White",
            assetName: "iPhone Air - Cloud White - Portrait",
            screenSize: .init(width: 1260, height: 2736)
        ),
        Device(
            id: "iphone-air-light-gold",
            generation: "iPhone Air",
            variant: "Air",
            finish: "Light Gold",
            assetName: "iPhone Air - Light Gold - Portrait",
            screenSize: .init(width: 1260, height: 2736)
        ),
        Device(
            id: "iphone-air-sky-blue",
            generation: "iPhone Air",
            variant: "Air",
            finish: "Sky Blue",
            assetName: "iPhone Air - Sky Blue - Portrait",
            screenSize: .init(width: 1260, height: 2736)
        ),
        Device(
            id: "iphone-air-space-black",
            generation: "iPhone Air",
            variant: "Air",
            finish: "Space Black",
            assetName: "iPhone Air - Space Black - Portrait",
            screenSize: .init(width: 1260, height: 2736)
        ),
        Device(
            id: "iphone-16-black",
            generation: "iPhone 16",
            variant: "Standard",
            finish: "Black",
            assetName: "iPhone 16 - Black - Portrait",
            screenSize: .init(width: 1179, height: 2556)
        ),
        Device(
            id: "iphone-16-pink",
            generation: "iPhone 16",
            variant: "Standard",
            finish: "Pink",
            assetName: "iPhone 16 - Pink - Portrait",
            screenSize: .init(width: 1179, height: 2556)
        ),
        Device(
            id: "iphone-16-teal",
            generation: "iPhone 16",
            variant: "Standard",
            finish: "Teal",
            assetName: "iPhone 16 - Teal - Portrait",
            screenSize: .init(width: 1179, height: 2556)
        ),
        Device(
            id: "iphone-16-ultramarine",
            generation: "iPhone 16",
            variant: "Standard",
            finish: "Ultramarine",
            assetName: "iPhone 16 - Ultramarine - Portrait",
            screenSize: .init(width: 1179, height: 2556)
        ),
        Device(
            id: "iphone-16-white",
            generation: "iPhone 16",
            variant: "Standard",
            finish: "White",
            assetName: "iPhone 16 - White - Portrait",
            screenSize: .init(width: 1179, height: 2556)
        ),

        Device(
            id: "iphone-16-plus-black",
            generation: "iPhone 16",
            variant: "Plus",
            finish: "Black",
            assetName: "iPhone 16 Plus - Black - Portrait",
            screenSize: .init(width: 1290, height: 2796)
        ),
        Device(
            id: "iphone-16-plus-pink",
            generation: "iPhone 16",
            variant: "Plus",
            finish: "Pink",
            assetName: "iPhone 16 Plus - Pink - Portrait",
            screenSize: .init(width: 1290, height: 2796)
        ),
        Device(
            id: "iphone-16-plus-teal",
            generation: "iPhone 16",
            variant: "Plus",
            finish: "Teal",
            assetName: "iPhone 16 Plus - Teal - Portrait",
            screenSize: .init(width: 1290, height: 2796)
        ),
        Device(
            id: "iphone-16-plus-ultramarine",
            generation: "iPhone 16",
            variant: "Plus",
            finish: "Ultramarine",
            assetName: "iPhone 16 Plus - Ultramarine - Portrait",
            screenSize: .init(width: 1290, height: 2796)
        ),
        Device(
            id: "iphone-16-plus-white",
            generation: "iPhone 16",
            variant: "Plus",
            finish: "White",
            assetName: "iPhone 16 Plus - White - Portrait",
            screenSize: .init(width: 1290, height: 2796)
        ),

        Device(
            id: "iphone-16-pro-black-titanium",
            generation: "iPhone 16",
            variant: "Pro",
            finish: "Black Titanium",
            assetName: "iPhone 16 Pro - Black Titanium - Portrait",
            screenSize: .init(width: 1206, height: 2622)
        ),
        Device(
            id: "iphone-16-pro-desert-titanium",
            generation: "iPhone 16",
            variant: "Pro",
            finish: "Desert Titanium",
            assetName: "iPhone 16 Pro - Desert Titanium - Portrait",
            screenSize: .init(width: 1206, height: 2622)
        ),
        Device(
            id: "iphone-16-pro-natural-titanium",
            generation: "iPhone 16",
            variant: "Pro",
            finish: "Natural Titanium",
            assetName: "iPhone 16 Pro - Natural Titanium - Portrait",
            screenSize: .init(width: 1206, height: 2622)
        ),
        Device(
            id: "iphone-16-pro-white-titanium",
            generation: "iPhone 16",
            variant: "Pro",
            finish: "White Titanium",
            assetName: "iPhone 16 Pro - White Titanium - Portrait",
            screenSize: .init(width: 1206, height: 2622)
        ),

        Device(
            id: "iphone-16-pro-max-black-titanium",
            generation: "iPhone 16",
            variant: "Pro Max",
            finish: "Black Titanium",
            assetName: "iPhone 16 Pro Max - Black Titanium - Portrait",
            screenSize: .init(width: 1320, height: 2868)
        ),
        Device(
            id: "iphone-16-pro-max-desert-titanium",
            generation: "iPhone 16",
            variant: "Pro Max",
            finish: "Desert Titanium",
            assetName: "iPhone 16 Pro Max - Desert Titanium - Portrait",
            screenSize: .init(width: 1320, height: 2868)
        ),
        Device(
            id: "iphone-16-pro-max-natural-titanium",
            generation: "iPhone 16",
            variant: "Pro Max",
            finish: "Natural Titanium",
            assetName: "iPhone 16 Pro Max - Natural Titanium - Portrait",
            screenSize: .init(width: 1320, height: 2868)
        ),
        Device(
            id: "iphone-16-pro-max-white-titanium",
            generation: "iPhone 16",
            variant: "Pro Max",
            finish: "White Titanium",
            assetName: "iPhone 16 Pro Max - White Titanium - Portrait",
            screenSize: .init(width: 1320, height: 2868)
        ),
        Device(
            id: "iphone-15-black",
            generation: "iPhone 15",
            variant: "Standard",
            finish: "Black",
            assetName: "iPhone 15 - Black - Portrait",
            screenSize: .init(width: 1179, height: 2556)
        ),
        Device(
            id: "iphone-15-blue",
            generation: "iPhone 15",
            variant: "Standard",
            finish: "Blue",
            assetName: "iPhone 15 - Blue - Portrait",
            screenSize: .init(width: 1179, height: 2556)
        ),
        Device(
            id: "iphone-15-green",
            generation: "iPhone 15",
            variant: "Standard",
            finish: "Green",
            assetName: "iPhone 15 - Green - Portrait",
            screenSize: .init(width: 1179, height: 2556)
        ),
        Device(
            id: "iphone-15-pink",
            generation: "iPhone 15",
            variant: "Standard",
            finish: "Pink",
            assetName: "iPhone 15 - Pink - Portrait",
            screenSize: .init(width: 1179, height: 2556)
        ),
        Device(
            id: "iphone-15-yellow",
            generation: "iPhone 15",
            variant: "Standard",
            finish: "Yellow",
            assetName: "iPhone 15 - Yellow - Portrait",
            screenSize: .init(width: 1179, height: 2556)
        ),

        Device(
            id: "iphone-15-plus-black",
            generation: "iPhone 15",
            variant: "Plus",
            finish: "Black",
            assetName: "iPhone 15 Plus - Black - Portrait",
            screenSize: .init(width: 1290, height: 2796)
        ),
        Device(
            id: "iphone-15-plus-blue",
            generation: "iPhone 15",
            variant: "Plus",
            finish: "Blue",
            assetName: "iPhone 15 Plus - Blue - Portrait",
            screenSize: .init(width: 1290, height: 2796)
        ),
        Device(
            id: "iphone-15-plus-green",
            generation: "iPhone 15",
            variant: "Plus",
            finish: "Green",
            assetName: "iPhone 15 Plus - Green - Portrait",
            screenSize: .init(width: 1290, height: 2796)
        ),
        Device(
            id: "iphone-15-plus-pink",
            generation: "iPhone 15",
            variant: "Plus",
            finish: "Pink",
            assetName: "iPhone 15 Plus - Pink - Portrait",
            screenSize: .init(width: 1290, height: 2796)
        ),
        Device(
            id: "iphone-15-plus-yellow",
            generation: "iPhone 15",
            variant: "Plus",
            finish: "Yellow",
            assetName: "iPhone 15 Plus - Yellow - Portrait",
            screenSize: .init(width: 1290, height: 2796)
        ),

        Device(
            id: "iphone-15-pro-black-titanium",
            generation: "iPhone 15",
            variant: "Pro",
            finish: "Black Titanium",
            assetName: "iPhone 15 Pro - Black Titanium - Portrait",
            screenSize: .init(width: 1179, height: 2556)
        ),
        Device(
            id: "iphone-15-pro-blue-titanium",
            generation: "iPhone 15",
            variant: "Pro",
            finish: "Blue Titanium",
            assetName: "iPhone 15 Pro - Blue Titanium - Portrait",
            screenSize: .init(width: 1179, height: 2556)
        ),
        Device(
            id: "iphone-15-pro-natural-titanium",
            generation: "iPhone 15",
            variant: "Pro",
            finish: "Natural Titanium",
            assetName: "iPhone 15 Pro - Natural Titanium - Portrait",
            screenSize: .init(width: 1179, height: 2556)
        ),
        Device(
            id: "iphone-15-pro-white-titanium",
            generation: "iPhone 15",
            variant: "Pro",
            finish: "White Titanium",
            assetName: "iPhone 15 Pro - White Titanium - Portrait",
            screenSize: .init(width: 1179, height: 2556)
        ),

        Device(
            id: "iphone-15-pro-max-black-titanium",
            generation: "iPhone 15",
            variant: "Pro Max",
            finish: "Black Titanium",
            assetName: "iPhone 15 Pro Max - Black Titanium - Portrait",
            screenSize: .init(width: 1290, height: 2796)
        ),
        Device(
            id: "iphone-15-pro-max-blue-titanium",
            generation: "iPhone 15",
            variant: "Pro Max",
            finish: "Blue Titanium",
            assetName: "iPhone 15 Pro Max - Blue Titanium - Portrait",
            screenSize: .init(width: 1290, height: 2796)
        ),
        Device(
            id: "iphone-15-pro-max-natural-titanium",
            generation: "iPhone 15",
            variant: "Pro Max",
            finish: "Natural Titanium",
            assetName: "iPhone 15 Pro Max - Natural Titanium - Portrait",
            screenSize: .init(width: 1290, height: 2796)
        ),
        Device(
            id: "iphone-15-pro-max-white-titanium",
            generation: "iPhone 15",
            variant: "Pro Max",
            finish: "White Titanium",
            assetName: "iPhone 15 Pro Max - White Titanium - Portrait",
            screenSize: .init(width: 1290, height: 2796)
        ),
        Device(
            id: "iphone-14-blue",
            generation: "iPhone 14",
            variant: "Standard",
            finish: "Blue",
            assetName: "iPhone 14 - Blue - Portrait",
            screenSize: .init(width: 1170, height: 2532)
        ),
        Device(
            id: "iphone-14-midnight",
            generation: "iPhone 14",
            variant: "Standard",
            finish: "Midnight",
            assetName: "iPhone 14 - Midnight - Portrait",
            screenSize: .init(width: 1170, height: 2532)
        ),
        Device(
            id: "iphone-14-purple",
            generation: "iPhone 14",
            variant: "Standard",
            finish: "Purple",
            assetName: "iPhone 14 - Purple - Portrait",
            screenSize: .init(width: 1170, height: 2532)
        ),
        Device(
            id: "iphone-14-red",
            generation: "iPhone 14",
            variant: "Standard",
            finish: "Red",
            assetName: "iPhone 14 - Red - Portrait",
            screenSize: .init(width: 1170, height: 2532)
        ),
        Device(
            id: "iphone-14-starlight",
            generation: "iPhone 14",
            variant: "Standard",
            finish: "Starlight",
            assetName: "iPhone 14 - Starlight - Portrait",
            screenSize: .init(width: 1170, height: 2532)
        ),

        Device(
            id: "iphone-14-plus-blue",
            generation: "iPhone 14",
            variant: "Plus",
            finish: "Blue",
            assetName: "iPhone 14 Plus - Blue - Portrait",
            screenSize: .init(width: 1284, height: 2778)
        ),
        Device(
            id: "iphone-14-plus-midnight",
            generation: "iPhone 14",
            variant: "Plus",
            finish: "Midnight",
            assetName: "iPhone 14 Plus - Midnight - Portrait",
            screenSize: .init(width: 1284, height: 2778)
        ),
        Device(
            id: "iphone-14-plus-purple",
            generation: "iPhone 14",
            variant: "Plus",
            finish: "Purple",
            assetName: "iPhone 14 Plus - Purple - Portrait",
            screenSize: .init(width: 1284, height: 2778)
        ),
        Device(
            id: "iphone-14-plus-red",
            generation: "iPhone 14",
            variant: "Plus",
            finish: "Red",
            assetName: "iPhone 14 Plus - Red - Portrait",
            screenSize: .init(width: 1284, height: 2778)
        ),
        Device(
            id: "iphone-14-plus-starlight",
            generation: "iPhone 14",
            variant: "Plus",
            finish: "Starlight",
            assetName: "iPhone 14 Plus - Starlight - Portrait",
            screenSize: .init(width: 1284, height: 2778)
        ),

        Device(
            id: "iphone-14-pro-deep-purple",
            generation: "iPhone 14",
            variant: "Pro",
            finish: "Deep Purple",
            assetName: "iPhone 14 Pro - Deep Purple - Portrait",
            screenSize: .init(width: 1179, height: 2556)
        ),
        Device(
            id: "iphone-14-pro-gold",
            generation: "iPhone 14",
            variant: "Pro",
            finish: "Gold",
            assetName: "iPhone 14 Pro - Gold - Portrait",
            screenSize: .init(width: 1179, height: 2556)
        ),
        Device(
            id: "iphone-14-pro-silver",
            generation: "iPhone 14",
            variant: "Pro",
            finish: "Silver",
            assetName: "iPhone 14 Pro - Silver - Portrait",
            screenSize: .init(width: 1179, height: 2556)
        ),
        Device(
            id: "iphone-14-pro-space-black",
            generation: "iPhone 14",
            variant: "Pro",
            finish: "Space Black",
            assetName: "iPhone 14 Pro - Space Black - Portrait",
            screenSize: .init(width: 1179, height: 2556)
        ),

        Device(
            id: "iphone-14-pro-max-deep-purple",
            generation: "iPhone 14",
            variant: "Pro Max",
            finish: "Deep Purple",
            assetName: "iPhone 14 Pro Max - Deep Purple - Portrait",
            screenSize: .init(width: 1290, height: 2796)
        ),
        Device(
            id: "iphone-14-pro-max-gold",
            generation: "iPhone 14",
            variant: "Pro Max",
            finish: "Gold",
            assetName: "iPhone 14 Pro Max - Gold - Portrait",
            screenSize: .init(width: 1290, height: 2796)
        ),
        Device(
            id: "iphone-14-pro-max-silver",
            generation: "iPhone 14",
            variant: "Pro Max",
            finish: "Silver",
            assetName: "iPhone 14 Pro Max - Silver - Portrait",
            screenSize: .init(width: 1290, height: 2796)
        ),
        Device(
            id: "iphone-14-pro-max-space-black",
            generation: "iPhone 14",
            variant: "Pro Max",
            finish: "Space Black",
            assetName: "iPhone 14 Pro Max - Space Black - Portrait",
            screenSize: .init(width: 1290, height: 2796)
        ),
        Device(
            id: "iphone-13-midnight",
            generation: "iPhone 13",
            variant: "Standard",
            finish: "Midnight",
            assetName: "iPhone 13 - Midnight",
            screenSize: .init(width: 1170, height: 2532)
        ),
        Device(
            id: "iphone-13-starlight",
            generation: "iPhone 13",
            variant: "Standard",
            finish: "Starlight",
            assetName: "iPhone 13 - Starlight",
            screenSize: .init(width: 1170, height: 2532)
        ),

        Device(
            id: "iphone-13-mini-midnight",
            generation: "iPhone 13",
            variant: "Mini",
            finish: "Midnight",
            assetName: "iPhone 13 mini - Midnight",
            screenSize: .init(width: 1080, height: 2340)
        ),
        Device(
            id: "iphone-13-mini-starlight",
            generation: "iPhone 13",
            variant: "Mini",
            finish: "Starlight",
            assetName: "iPhone 13 mini - Starlight",
            screenSize: .init(width: 1080, height: 2340)
        ),

        Device(
            id: "iphone-13-pro-graphite",
            generation: "iPhone 13",
            variant: "Pro",
            finish: "Graphite",
            assetName: "iPhone 13 Pro - Graphite - Portrait",
            screenSize: .init(width: 1170, height: 2532)
        ),
        Device(
            id: "iphone-13-pro-silver",
            generation: "iPhone 13",
            variant: "Pro",
            finish: "Silver",
            assetName: "iPhone 13 Pro - Silver - Portrait",
            screenSize: .init(width: 1170, height: 2532)
        ),

        Device(
            id: "iphone-13-pro-max-graphite",
            generation: "iPhone 13",
            variant: "Pro Max",
            finish: "Graphite",
            assetName: "iPhone 13 Pro Max - Graphite - Portrait",
            screenSize: .init(width: 1284, height: 2778)
        ),
        Device(
            id: "iphone-13-pro-max-silver",
            generation: "iPhone 13",
            variant: "Pro Max",
            finish: "Silver",
            assetName: "iPhone 13 Pro Max - Silver - Portrait",
            screenSize: .init(width: 1284, height: 2778)
        ),
        Device(
            id: "iphone-12-white",
            generation: "iPhone 12",
            variant: "Standard",
            finish: "White",
            assetName: "iPhone 12 - White - Portrait",
            screenSize: .init(width: 1170, height: 2532)
        ),
        Device(
            id: "iphone-12-mini-white",
            generation: "iPhone 12",
            variant: "Mini",
            finish: "White",
            assetName: "iPhone 12 Mini - White - Portrait",
            screenSize: .init(width: 1125, height: 2436)
        ),
        Device(
            id: "iphone-12-pro-silver",
            generation: "iPhone 12",
            variant: "Pro",
            finish: "Silver",
            assetName: "iPhone 12 Pro - Silver - Portrait",
            screenSize: .init(width: 1170, height: 2532)
        ),
        Device(
            id: "iphone-12-pro-max-silver",
            generation: "iPhone 12",
            variant: "Pro Max",
            finish: "Silver",
            assetName: "iPhone 12 Pro Max - Silver - Portrait",
            screenSize: .init(width: 1284, height: 2778)
        ),
        Device(
            id: "iphone-11",
            generation: "iPhone 11",
            variant: "Standard",
            finish: "Default",
            assetName: "iPhone 11 - Portrait",
            screenSize: .init(width: 828, height: 1792)
        ),
        Device(
            id: "iphone-11-pro",
            generation: "iPhone 11",
            variant: "Pro",
            finish: "Default",
            assetName: "iPhone 11 Pro - Portrait",
            screenSize: .init(width: 1125, height: 2436)
        ),
        Device(
            id: "iphone-11-pro-max",
            generation: "iPhone 11",
            variant: "Pro Max",
            finish: "Default",
            assetName: "iPhone 11 Pro Max - Portrait",
            screenSize: .init(width: 1242, height: 2688)
        )
    ]
    
    public static var generations: [String] {
        all.map(\.generation).unique()
    }

    public static func variants(for generation: String) -> [String] {
        all
            .filter { $0.generation == generation }
            .map(\.variant)
            .unique()
    }

    public static func devices(
        for generation: String,
        variant: String
    ) -> [Device] {
        all.filter {
            $0.generation == generation &&
            $0.variant == variant
        }
    }
}

private extension Sequence where Element: Hashable {

    func unique() -> [Element] {
        var seen = Set<Element>()

        return filter {
            seen.insert($0).inserted
        }
    }
}

//https://devimages-cdn.apple.com/design/resources/download/Bezel-iPhone-16.dmg
