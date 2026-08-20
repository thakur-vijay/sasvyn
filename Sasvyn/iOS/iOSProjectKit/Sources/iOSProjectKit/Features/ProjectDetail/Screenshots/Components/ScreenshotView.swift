//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 16/08/26.
//

import SwiftUI
import SVRemoteImage

struct ScreenshotView: View {
    let screenshot: ProjectScreenshot
    let size: CGSize
    var body: some View {
        let cornerRadius: CGFloat = 20
        if let url = screenshot.imageURL {
            SVRemoteImage(
                url: url,
                size: size,
                shape: .rect(cornerRadius: cornerRadius, style: .continuous)
            )
        }else {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.fill)

                VStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.title3.weight(.medium))

                    Text("Add")
                        .font(.caption.weight(.medium))
                }
                .foregroundStyle(.secondary)
            }
            .frame(width: size.width, height: size.height)
        }
    }
}
