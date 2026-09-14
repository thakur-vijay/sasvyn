//
//  SafariView.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 01/09/26.
//

import SwiftUI

#if os(iOS)
import SafariServices

internal struct SafariView: UIViewControllerRepresentable {

    private let item: WebItem

    init(item: WebItem) {
        self.item = item
    }

    func makeUIViewController(
        context: Context
    ) -> SFSafariViewController {
        let controller = SFSafariViewController(url: item.url)
        controller.title = item.title
        return controller
    }

    func updateUIViewController(
        _ viewController: SFSafariViewController,
        context: Context
    ) {
        // Nothing to update.
    }
}

#elseif os(macOS)
import AppKit

internal struct SafariView: View {

    private let item: WebItem

    init(item: WebItem) {
        self.item = item
    }

    var body: some View {
        Color.clear
            .onAppear {
                NSWorkspace.shared.open(item.url)
            }
    }
}
#endif
