//
//  File.swift
//  iOSAppearanceKit
//
//  Created by Vijay Thakur on 03/09/26.
//

import SwiftUI
import ComposableArchitecture
import Combine
import SVDesignSystem


public enum AppearanceMode: String, CaseIterable, Identifiable {
    case light
    case dark
    case system

    public var id: Self { self }

    public func image() -> ImageResource {
        switch self {
        case .light:
            .lightMode

        case .dark:
            .darkMode

        case .system: .darkMode
        }
    }
    
    public func colorScheme() -> ColorScheme? {
        switch self {
        case .light: .light
        case .dark: .dark
        case .system: nil
        }
    }

}

public struct iOSAppearanceView: View {
    let store: StoreOf<iOSAppearanceFeature>

    @AppStorage("appTint") private var appTint: AppTint = .azure
    @AppStorage("appearanceMode") private var appearanceMode: AppearanceMode = .system

    public init(store: StoreOf<iOSAppearanceFeature>) {
        self.store = store
    }

    public var body: some View {
        List {
            Section("Appearance") {
                HStack(spacing: 16) {
                    ForEach(AppearanceMode.allCases) { mode in
                        VStack(spacing: 12) {
                            GeometryReader { proxy in
                                appearancePreview(for: mode)
                            }
                            .aspectRatio(1284 / 2778, contentMode: .fit)
                            .clipShape(.rect(cornerRadius: 16, style: .continuous))
                            
                            HStack(spacing: 8) {
                                if appearanceMode == mode {
                                    SVSymbols.Check.circle.image
                                        .foregroundStyle(Color.accentColor)
                                }
                                Text(mode.rawValue.uppercased())
                                    .font(.headline)
                            }

                        }
                        .contentShape(.rect)
                        .onTapGesture {
                            appearanceMode = mode
                        }
                    }
                }
            }
            .listRowSeparator(.hidden)

            Section("App Tint") {
                ForEach(AppTint.allCases) { tint in
                    Button {
                        appTint = tint
                    } label: {
                        HStack(spacing: 16) {
                            Circle()
                                .fill(tint.color)
                                .frame(width: 30, height: 30)

                            Text(tint.rawValue.capitalized)

                            Spacer()

                            if appTint == tint {
                                SVSymbols.Check.plain.image
                                    .foregroundStyle(appTint.color)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Appearance")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func appearancePreview(for mode: AppearanceMode) -> some View {
        switch mode {
        case .light:
            Image(.lightMode)
                .resizable()
                .aspectRatio(contentMode: .fit)

        case .dark:
            Image(.darkMode)
                .resizable()
                .aspectRatio(contentMode: .fit)

        case .system:
            GeometryReader { proxy in
                ZStack {
                    Image(.darkMode)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            width: proxy.size.width,
                            height: proxy.size.height
                        )

                    Image(.lightMode)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            width: proxy.size.width,
                            height: proxy.size.height
                        )
                        .mask(alignment: .leading) {
                            Rectangle()
                                .frame(width: proxy.size.width / 2)
                        }
                }
            }
        }
    }
}
