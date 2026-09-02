//
//  File.swift
//  iOSHomeKit
//
//  Created by Vijay Thakur on 02/09/26.
//

import SwiftUI
import SVDesignSystem

internal struct CreatePortfolioSection: View {
    var body: some View {
        ContentUnavailableView {
            VStack {
                Text("Build Your")
                    .font(.title2.bold())
                SVGradientText(
                    text: "Professional Portfolio",
                    colors: [
                        .blue,
                        .red,
                        .pink,
                    ],
                )
                .font(.title.bold())
            }
            .textCase(.uppercase)

        } description: {
            SVGradientText(
                text: "Create a professional portfolio that showcases your skills, experience, and best work.",
                colors: [.gray, .white]
            )
            .font(.callout)
        } actions: {
            SVButton("Create Portfolio", systemImage: "plus") {
                
            }
        }
    }
}
