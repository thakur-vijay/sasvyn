//
//  File.swift
//  iOSAboutKit
//
//  Created by Vijay Thakur on 11/08/26.
//
//

import SwiftUI
import ComposableArchitecture
import InfomaniakRichHTMLEditor

public struct iOSAboutView: View {

    @Bindable
    var store: StoreOf<iOSAboutFeature>

    public init(store: StoreOf<iOSAboutFeature>) {
        self.store = store
    }

    @StateObject private var textAttributes: TextAttributes = .init()
    @State private var debounceTask: Task<Void, Never>?
    public var body: some View {
        RichHTMLEditor(html: $store.about.content, textAttributes: textAttributes)
            .editorScrollable(true)
            .editorInputAccessoryView(EditorSwiftUIToolbar(textAttributes: textAttributes))
            .padding(20)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await store.send(.onTask).finish()
            }
            .onChange(of: store.about.content) { _, newValue in
                debounceTask?.cancel()
                debounceTask = Task { @MainActor in
                    try? await Task.sleep(for: .milliseconds(500))
                    guard !Task.isCancelled else { return }
                    store.send(.onContentChange)
                }
            }
    }

}

struct EditorSwiftUIToolbarContent: View {
    @ObservedObject var textAttributes: TextAttributes

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 4) {
                EditorToolbarButton(systemImage: "bold", isActive: textAttributes.hasBold) {
                    textAttributes.bold()
                }
                EditorToolbarButton(systemImage: "italic", isActive: textAttributes.hasItalic) {
                    textAttributes.italic()
                }
                EditorToolbarButton(systemImage: "underline", isActive: textAttributes.hasUnderline) {
                    textAttributes.underline()
                }
                EditorToolbarButton(systemImage: "strikethrough", isActive: textAttributes.hasStrikethrough) {
                    textAttributes.strikethrough()
                }
                EditorToolbarButton(
                    systemImage: "textformat.size.smaller",
                    isActive: false
                ) {
                    guard let size = textAttributes.fontSize else { return }
                    textAttributes.setFontSize(max(size - 1, 8))
                }

                EditorToolbarButton(
                    systemImage: "textformat.size.larger",
                    isActive: false
                ) {
                    guard let size = textAttributes.fontSize else { return }
                    textAttributes.setFontSize(min(size + 1, 72))
                }
                
                Divider()
                    .frame(height: 20)

                EditorToolbarButton(systemImage: "list.number", isActive: textAttributes.hasOrderedList) {
                    textAttributes.orderedList()
                }
                EditorToolbarButton(systemImage: "list.bullet", isActive: textAttributes.hasUnorderedList) {
                    textAttributes.unorderedList()
                }

                Divider()
                    .frame(height: 20)

                EditorToolbarButton(systemImage: "decrease.indent", isActive: false) {
                    textAttributes.outdent()
                }
                EditorToolbarButton(systemImage: "increase.indent", isActive: false) {
                    textAttributes.indent()
                }

                Divider()
                    .frame(height: 20)

                EditorToolbarButton(systemImage: "arrow.uturn.backward", isActive: false) {
                    textAttributes.undo()
                }
                EditorToolbarButton(systemImage: "arrow.uturn.forward", isActive: false) {
                    textAttributes.redo()
                }
            }
            .padding(.horizontal, 4)
        }
        .scrollIndicators(.hidden)
        .frame(height: 44)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 12))
        .padding(.horizontal)
    }
}

// MARK: - Toolbar button

struct EditorToolbarButton: View {
    let systemImage: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.body)
                .frame(width: 36, height: 36)
                .foregroundStyle(isActive ? Color.accentColor : .primary)
                .background(isActive ? Color.accentColor.opacity(0.2) : .clear, in: .rect(cornerRadius: 12))
        }
    }
}

// MARK: - UIView wrapper for input accessory

final class EditorSwiftUIToolbar: UIView {
    private let hostingController: UIHostingController<EditorSwiftUIToolbarContent>

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 44)
    }

    init(textAttributes: TextAttributes) {
        hostingController = UIHostingController(rootView: EditorSwiftUIToolbarContent(textAttributes: textAttributes))
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        autoresizingMask = .flexibleWidth

        addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
