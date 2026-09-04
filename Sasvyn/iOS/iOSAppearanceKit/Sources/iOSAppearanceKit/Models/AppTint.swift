//
//  AppTint.swift
//  iOSAppearanceKit
//
//  Created by Vijay Thakur on 03/09/26.
//

import SwiftUI

public enum AppTint: String, CaseIterable, Identifiable {
    case blue
    case azure
    case sky
    case cyan
    case teal
    case mint
    case green
    case emerald
    case lime
    case chartreuse
    case yellow
    case gold
    case orange
    case amber
    case tangerine
    case red
    case coral
    case rose
    case lavender
    case indigo

    public var id: Self { self }

    public var color: Color {
        switch self {
        case .blue:
            .blue

        case .azure:
            Color(red: 64 / 255, green: 156 / 255, blue: 1)

        case .sky:
            Color(red: 100 / 255, green: 210 / 255, blue: 1)

        case .cyan:
            .cyan

        case .teal:
            .teal

        case .mint:
            .mint

        case .green:
            .green

        case .emerald:
            Color(red: 125 / 255, green: 219 / 255, blue: 99 / 255)

        case .lime:
            Color(red: 168 / 255, green: 231 / 255, blue: 46 / 255)

        case .chartreuse:
            Color(red: 208 / 255, green: 241 / 255, blue: 0)

        case .yellow:
            .yellow

        case .gold:
            Color(red: 1, green: 204 / 255, blue: 0)

        case .orange:
            .orange

        case .amber:
            Color(red: 1, green: 122 / 255, blue: 0)

        case .tangerine:
            Color(red: 1, green: 106 / 255, blue: 0)

        case .red:
            .red

        case .coral:
            Color(red: 1, green: 90 / 255, blue: 95 / 255)

        case .rose:
            Color(red: 1, green: 45 / 255, blue: 85 / 255)

        case .lavender:
            Color(red: 191 / 255, green: 90 / 255, blue: 242 / 255)

        case .indigo:
            .indigo
        }
    }
    
    public var colorHex: Color {
        switch self {
        case .blue:
            Color(hex: "#007AFF")
        case .azure:
            Color(hex: "#409CFF")
        case .sky:
            Color(hex: "#64D2FF")
        case .cyan:
            Color(hex: "#007AFF")
        case .teal:
            Color(hex: "#007AFF")
        case .mint:
            Color(hex: "#007AFF")
        case .green:
            Color(hex: "#007AFF")
        case .emerald:
            Color(hex: "#007AFF")
        case .lime:
            Color(hex: "#007AFF")
        case .chartreuse:
            Color(hex: "#007AFF")
        case .yellow:
            Color(hex: "#007AFF")
        case .gold:
            Color(hex: "#007AFF")
        case .orange:
            Color(hex: "#007AFF")
        case .amber:
            Color(hex: "#007AFF")
        case .tangerine:
            Color(hex: "#007AFF")
        case .red:
            Color(hex: "#007AFF")
        case .coral:
            Color(hex: "#007AFF")
        case .rose:
            Color(hex: "#007AFF")
        case .lavender:
            Color(hex: "#007AFF")
        case .indigo:
            Color(hex: "#007AFF")
        }
    }
}
//
//Sky
//#64D2FF
//Cyan
//#5AC8FA
//Teal
//#30B0C7
//Mint
//#00C7BE
//Green
//#34C759
//Emerald
//#7DDB63
//Lime
//#A8E72E
//Chartreuse
//#D0F100
//Yellow
//#FFD60A
//Gold
//#FFCC00
//Orange
//#FF9500
//Amber
//#FF7A00
//Tangerine
//#FF6A00
//Red
//#FF3B30
//Coral
//#FF5A5F
//Rose
//#FF2D55
//Lavender
//#BF5AF2
//Indigo
//#5856D6


extension Color {

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)

        var value: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&value)

        let red = Double((value >> 16) & 0xFF) / 255
        let green = Double((value >> 8) & 0xFF) / 255
        let blue = Double(value & 0xFF) / 255

        self.init(
            red: red,
            green: green,
            blue: blue
        )
    }
}
