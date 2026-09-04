//
//  File.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 19/08/26.
//

import SwiftUI

public protocol SVCategory: Identifiable, Equatable, Sendable where ID == String{
    var title: String { get }
}

public extension View {
    @ViewBuilder
    func categoryPicker<T: SVCategory>(
        isPresented: Binding<Bool>,
        title: String = "Select Category",
        buttonTitle: String = "Add Category",
        categories: [T],
        selection: Binding<T?>,
        onDismiss: @escaping ()->() = {}
    )-> some View {
        self
            .sheet(isPresented: isPresented) {
                CategoryPicker(title: title, buttonTitle: buttonTitle, categories: categories) { category in
                    selection.wrappedValue = category
                    isPresented.wrappedValue = false
                } onDismiss: {
                    isPresented.wrappedValue = false
                    onDismiss()
                }
                .interactiveDismissDisabled()
            }
    }
}

internal struct CategoryPicker<T: SVCategory>: View {
    let title: String
    let buttonTitle: String
    let categories: [T]
    var add: (T)->()
    var onDismiss: ()->()
    @State private var height: CGFloat = 0
    @State private var selectedCategory: T?
    var body: some View {
        VStack(alignment: .leading, spacing: 25){
            HStack {
                Text(title)
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button {
                    onDismiss()
                } label: {
                    Image(systemName: "xmark")
                        .frame(width: 40, height: 40)
                }
                .optionalGlassEffect(.circle)
            }
            ChipLayoutUI(alignment: .leading, spacing: 12){
                ForEach(categories) { category in
                    SVChip(
                        model: .init(id: category.id, text: category.title),
                        isSelected: selectedCategory?.id == category.id) {
                            selectedCategory = category
                        }
                }
            }
            
            SVButton(
                buttonTitle,
                systemImage: "plus"
            ) {
                if let selectedCategory {
                    add(selectedCategory)
                }
            }
            .allowsTightening(!selectedCategory.isNull)

        }
        .safeAreaPadding(.horizontal, 20)
        .safeAreaPadding(.vertical, 15)
        .onGeometryChange(for: CGFloat.self) {
            $0.size.height
        } action: { newValue in
            height = newValue
        }
        .presentationDetents([.height(height)])
    }
}

internal extension Optional {
    var isNull: Bool {
        self == nil
    }
}
