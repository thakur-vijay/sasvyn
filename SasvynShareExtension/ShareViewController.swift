//
//  ShareViewController.swift
//  SasvynShareExtension
//
//  Created by Vijay Thakur on 04/09/26.
//

import UIKit
import SwiftUI
import ComposableArchitecture
import iOSMockupKit
import SVMockupKit
import SVDatabaseKit
import SVDIInfra
internal import UniformTypeIdentifiers

final class ShareViewController: UIViewController {

    private var hostingController: UIHostingController<AnyView>?

    override func viewDidLoad() {
        super.viewDidLoad()

        isModalInPresentation = true

        let database = SVDatabaseContainer()
        let container = MockupsDIContainer(database: database.appDatabase)

        let store = Store(
            initialState: iOSCreateMockupFeature.State()
        ) {
            iOSCreateMockupFeature()
        } withDependencies: {
            container.register(&$0)
        }

        let view = iOSCreateMockupView(
            store: store,
            onDismiss: { [weak self] in
                self?.extensionContext?.completeRequest(
                    returningItems: nil
                )
            }
        )

        let hostingController = UIHostingController(
            rootView: AnyView(view)
        )

        addChild(hostingController)

        hostingController.view.frame = self.view.bounds
        hostingController.view.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight
        ]

        self.view.addSubview(hostingController.view)

        hostingController.didMove(toParent: self)

        self.hostingController = hostingController

        loadSharedImages { [weak store] data in
            guard let store else {
                print("Store not found")
                return
            }

            store.send(.onItemProvidersLoaded(data))
        }
    }

    private func loadSharedImages(
        completion: @escaping ([Data]) -> Void
    ) {
        guard
            let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
            let attachments = extensionItem.attachments
        else {
            print("No attachments")
            completion([])
            return
        }

        let imageProviders = Array(attachments.prefix(10))
        let results = ImageResults()

        let group = DispatchGroup()

        for imageProvider in imageProviders {
            group.enter()

           let _ = imageProvider.loadDataRepresentation(for: .image) { data, error in
                defer {
                    group.leave()
                }

                guard let data, error == nil else {
                    return
                }

                results.append(data)
            }
        }

        group.notify(queue: .main) {
            completion(results.get())
        }
    }
}

private final class ImageResults: @unchecked Sendable {
    private let lock = NSLock()
    private var values: [Data] = []

    func append(_ data: Data) {
        lock.lock()
        defer { lock.unlock() }
        values.append(data)
    }

    func get() -> [Data] {
        lock.lock()
        defer { lock.unlock() }
        return values
    }
}
