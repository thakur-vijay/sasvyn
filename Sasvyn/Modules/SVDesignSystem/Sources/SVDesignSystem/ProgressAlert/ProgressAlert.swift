//
//  File.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 06/09/26.
//

import SwiftUI

public struct ProgressAlertConfig {
    public var tint: Color
    public var title: String
    public var message: String

    public init(
        tint: Color,
        title: String,
        message: String
    ) {
        self.tint = tint
        self.title = title
        self.message = message
    }
}

public extension View {

    @ViewBuilder
    func progressAlert<Actions: View>(
        config: ProgressAlertConfig,
        isPresented: Binding<Bool>,
        progress: Binding<CGFloat>,
        @ViewBuilder actions: @escaping () -> Actions
    ) -> some View {
        self
            .alert(
                config.title,
                isPresented: isPresented,
                actions: actions
            ) {
                Text("\(config.message)\n")
            }
            .animation(.linear, value: progress.wrappedValue)
            .background {
                ProgressAlertBridge(
                    config: config,
                    progress: progress,
                    isPresented: isPresented
                )
            }
    }
}

// MARK: - UIKit Bridge

private struct ProgressAlertBridge: UIViewRepresentable {

    let config: ProgressAlertConfig
    @Binding var progress: CGFloat
    @Binding var isPresented: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false

        context.coordinator.hostView = view

        return view
    }

    func updateUIView(
        _ uiView: UIView,
        context: Context
    ) {
        context.coordinator.config = config
        context.coordinator.progress = progress

        guard isPresented else {
            context.coordinator.removeProgressBar()
            return
        }

        context.coordinator.attachProgressBarIfNeeded()
        context.coordinator.updateProgressBar()
    }

    static func dismantleUIView(
        _ uiView: UIView,
        coordinator: Coordinator
    ) {
        coordinator.removeProgressBar()
    }

    // MARK: - Coordinator

    @MainActor
    final class Coordinator {

        weak var hostView: UIView?

        var config: ProgressAlertConfig?
        var progress: CGFloat = 0

        private weak var progressBar: UIProgressView?
        private weak var alertController: UIAlertController?

        private var isScheduled = false

        func attachProgressBarIfNeeded() {
            guard progressBar == nil else {
                updateProgressBar()
                return
            }

            guard !isScheduled else {
                return
            }

            isScheduled = true

            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }

                self.isScheduled = false

                guard let alertController = self.findAlertController() else {
                    return
                }

                self.attach(to: alertController)
            }
        }

        private func attach(to alertController: UIAlertController) {
            guard progressBar == nil else {
                updateProgressBar()
                return
            }

            alertController.view.layoutIfNeeded()

            let progressView = UIProgressView(progressViewStyle: .default)
            progressView.translatesAutoresizingMaskIntoConstraints = false
            progressView.progress = Float(progress.clamped)
            progressView.tintColor = UIColor(config?.tint ?? .accentColor)
            progressView.trackTintColor = UIColor.secondarySystemFill

            alertController.view.addSubview(progressView)

            let padding: CGFloat = isIOS26 ? 30 : 15

            NSLayoutConstraint.activate([
                progressView.leadingAnchor.constraint(
                    equalTo: alertController.view.leadingAnchor,
                    constant: padding
                ),
                progressView.trailingAnchor.constraint(
                    equalTo: alertController.view.trailingAnchor,
                    constant: -padding
                )
            ])

            if let contentView = findAlertContentView(
                in: alertController.view
            ) {
                let offset = contentView.frame.height - (
                    isIOS26 ? 8 : 20
                )

                progressView.topAnchor.constraint(
                    equalTo: alertController.view.topAnchor,
                    constant: max(offset, 0)
                ).isActive = true
            } else {
                progressView.centerYAnchor.constraint(
                    equalTo: alertController.view.centerYAnchor
                ).isActive = true
            }

            self.alertController = alertController
            self.progressBar = progressView

            updateProgressBar()
        }

        func updateProgressBar() {
            guard let progressBar else {
                return
            }

            progressBar.progress = Float(progress.clamped)

            if let tint = config?.tint {
                progressBar.tintColor = UIColor(tint)
            }
        }

        func removeProgressBar() {
            progressBar?.removeFromSuperview()
            progressBar = nil
            alertController = nil
        }

        // MARK: - Find Alert

        private func findAlertController() -> UIAlertController? {
            guard
                let window = foregroundKeyWindow(),
                let rootViewController = window.rootViewController
            else {
                return nil
            }

            return findAlert(
                from: rootViewController
            )
        }

        private func findAlert(
            from viewController: UIViewController
        ) -> UIAlertController? {

            if let alert = viewController as? UIAlertController {
                return alert
            }

            if let presented = viewController.presentedViewController {
                if let alert = findAlert(from: presented) {
                    return alert
                }
            }

            for child in viewController.children.reversed() {
                if let alert = findAlert(from: child) {
                    return alert
                }
            }

            return nil
        }

        // MARK: - Alert Content

        private func findAlertContentView(
            in view: UIView
        ) -> UIView? {

            if String(
                describing: type(of: view)
            ).contains("GroupHeaderScrollView") {
                return view
            }

            for subview in view.subviews {
                if let result = findAlertContentView(in: subview) {
                    return result
                }
            }

            return nil
        }

        // MARK: - Window

        private func foregroundKeyWindow() -> UIWindow? {
            UIApplication.shared.connectedScenes
                .compactMap {
                    $0 as? UIWindowScene
                }
                .filter {
                    $0.activationState == .foregroundActive
                }
                .flatMap {
                    $0.windows
                }
                .first {
                    $0.isKeyWindow
                }
        }

        // MARK: - iOS Version

        private var isIOS26: Bool {
            if #available(iOS 26, *) {
                return true
            }

            return false
        }
    }
}

// MARK: - Helpers

private extension CGFloat {

    var clamped: CGFloat {
        Swift.min(Swift.max(self, 0), 1)
    }
}
