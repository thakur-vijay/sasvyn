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
                Rectangle()
                    .fill(.fill)

                VStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                        .font(.largeTitle.bold())

                    Text("Add")
                        .font(.caption.weight(.medium))
                }
                .foregroundStyle(.secondary)
            }
            .frame(width: size.width, height: size.height)
            .deviceCornerClip()
        }
    }
}

extension View {
    @ViewBuilder
    func deviceCornerClip()-> some View {
        self
            .modifier(DeviceCornerRadiusModifier())
    }
}

struct DeviceCornerRadiusModifier: ViewModifier {
    
    @Environment(\.self) private var env
    func body(content: Content) -> some View {
        let deviceCornerRadius = UIScreen.main.displayCornerRadius
        content
            .clipShape(.rect(cornerRadius: deviceCornerRadius, style: .continuous))
            .contentShape(.rect(cornerRadius: deviceCornerRadius, style: .continuous))
    }
}

extension UIScreen {
    public var displayCornerRadius: CGFloat {
        guard let cornerRadius = self.value(forKey: "_displayCornerRadius") as? CGFloat else {
            assertionFailure("Failed to detect screen corner radius")
            return 0
        }

        return cornerRadius
    }
}
