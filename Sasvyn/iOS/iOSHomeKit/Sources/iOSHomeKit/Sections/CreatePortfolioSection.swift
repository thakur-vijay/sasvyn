//
//  File.swift
//  iOSHomeKit
//
//  Created by Vijay Thakur on 02/09/26.
//

import SwiftUI
import SVDesignSystem
import iOSAppearanceKit

internal struct CreatePortfolioSection: View {
    @AppStorage("appTint") private var appTint: AppTint = .azure
    var body: some View {
        ContentUnavailableView {
            VStack {
                Text("Build Your")
                    .font(.title2.bold())
                SVGradientText(
                    text: "Professional Portfolio",
                    colors: [
                        appTint.color,
                        AppTint.azure.color,
                        AppTint.cyan.color
                    ],
                )
                .font(.title.bold())
            }
            .textCase(.uppercase)

        } description: {
            SVGradientText(
                text: "Create a professional portfolio that showcases your skills, experience, and best work.",
                colors: [.gray, .primary]
            )
            .font(.callout)
        } actions: {
            SVButton("Create Portfolio", systemImage: SVSymbols.Add.plain.name) {
                
            }
        }
    }
}
