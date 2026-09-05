//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 16/08/26.
//

import SwiftUI
import SVRemoteImage
import SVProjectKit

struct ScreenshotView: View {
    let screenshot: ProjectScreenshot
    let size: CGSize
    var body: some View {
        let cornerRadius: CGFloat = 20
        SVRemoteImage(
            url: screenshot.imageURL,
            size: size,
            shape: .rect(cornerRadius: cornerRadius, style: .continuous)
        )
    }
}
