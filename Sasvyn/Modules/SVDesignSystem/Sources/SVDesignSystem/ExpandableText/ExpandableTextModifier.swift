//
//  ExpandableTextModifier.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 17/08/26.
//

import SwiftUI

@available(iOS 18.0, *)
internal struct ExpandableTextModifier: ViewModifier {
    var length: Int
    var moreText: String
    var blurRadius: CGFloat
    var animation: Animation
    
    @State private var limitedSize: CGSize = .zero
    @State private var fullSize: CGSize = .zero
    @State private var animatedProgress: CGFloat = .zero
    @State private var isEnabled: Bool = true
    func body(content: Content) -> some View {
        content
            .lineLimit(length)
            .opacity(0)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .onGeometryChange(for: CGSize.self) {
                $0.size
            } action: { newValue in
                limitedSize = newValue
            }
            .frame(height: isExpanded ? fullSize.height : nil)
            .overlay {
                GeometryReader {
                    let contentSize = $0.size
                    content
                        .textRenderer(
                            TruncationTextRenderer(
                                length: length,
                                moreText: moreText,
                                blurRadius: blurRadius,
                                progress: animatedProgress
                            )
                        )
                        .fixedSize(horizontal: false, vertical: true)
                        .onGeometryChange(for: CGSize.self) {
                            $0.size
                        } action: { newValue in
                            fullSize = newValue
                        }
                        .frame(
                            width: contentSize.width,
                            height: contentSize.height,
                            alignment: isExpanded ? .leading : .topLeading
                        )
                }
            }
            .optionalClip(blurRadius: blurRadius)
            .contentShape(.rect)
            .onTapGesture {
                isEnabled.toggle()
            }
            .onChange(of: isEnabled) { oldValue, newValue in
                withAnimation(animation) {
                    animatedProgress = !newValue ? 1 : 0
                }
            }
            .onAppear {
                animatedProgress = !isEnabled ? 1 : 0
            }
        
    }
    
    var isExpanded: Bool {
        animatedProgress == 1
    }
    
}
