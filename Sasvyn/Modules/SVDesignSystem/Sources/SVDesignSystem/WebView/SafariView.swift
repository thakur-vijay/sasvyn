//
//  SafariView.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 01/09/26.
//

import SwiftUI
import SafariServices

internal struct SafariView: UIViewControllerRepresentable {

    private let url: URL

    init(url: URL) {
        self.url = url
    }

    func makeUIViewController(
        context: Context
    ) -> SFSafariViewController {
        let controller = SFSafariViewController(url: url)
        return controller
    }

    func updateUIViewController(
        _ viewController: SFSafariViewController,
        context: Context
    ) {
        // Nothing to update.
    }
}


