//
//  File.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 11/08/26.
//

import SwiftUI

@available(iOS 18.0, *)
public struct ChipLayoutUI<Content: View>: View {
    private var alignment: Alignment
    private var spacing: CGFloat
    private let content: Content

    /// Creates a chip-based layout container.
    ///
    /// - Parameters:
    ///   - alignment: The horizontal alignment applied to each row of content.
    ///   - spacing: The spacing between elements and rows.
    ///   - content: A view builder that constructs the child views.
    public init(
        alignment: Alignment = .leading,
        spacing: CGFloat = 10,
        @ViewBuilder content: () -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }

    /// The content and behavior of the view.
    public var body: some View {
        ChipLayout(alignment: alignment, spacing: spacing) {
            content
        }
    }
}

@available(iOS 18.0, *)
fileprivate struct ChipLayout: Layout {
    private var alignment: Alignment = .center
    private var spacing: CGFloat = 10

    /// Creates a chip layout with the specified alignment and spacing.
    ///
    /// - Parameters:
    ///   - alignment: The horizontal alignment for each row.
    ///   - spacing: The spacing between items and rows.
    init(alignment: Alignment = .leading, spacing: CGFloat = 10) {
        self.alignment = alignment
        self.spacing = spacing
    }
    
    /// Calculates and returns the size that best fits the proposed size.
    ///
    /// - Parameters:
    ///   - proposal: The proposed size from the parent view.
    ///   - subviews: The subviews to be arranged.
    ///   - cache: A cache for storing intermediate layout data.
    ///
    /// - Returns: The size required to fit all subviews.
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? 0
        var height: CGFloat = 0
        
        let rows = generateRows(maxWidth, proposal, subviews)
        
        for (index, row) in rows.enumerated() {
            if index == (rows.count - 1) {
                height += row.maxHeight(proposal)
            } else {
                height += row.maxHeight(proposal) + spacing
            }
        }
        
        return .init(width: maxWidth, height: height)
    }
    
    /// Places subviews within the given bounds.
    ///
    /// - Parameters:
    ///   - bounds: The rectangle in which to place subviews.
    ///   - proposal: The size proposal from the parent.
    ///   - subviews: The subviews to position.
    ///   - cache: A cache for storing intermediate layout data.
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var origin = bounds.origin
        let maxWidth = bounds.width
        let rows = generateRows(maxWidth, proposal, subviews)
        
        for row in rows {
            /// Calculates the starting X position based on alignment.
            let leading: CGFloat = bounds.maxX - maxWidth
            let trailing = bounds.maxX - (row.reduce(CGFloat.zero) { partialResult, view in
                let width = view.sizeThatFits(proposal).width
                if view == row.last {
                    return partialResult + width
                }
                return partialResult + width + spacing
            })
            let center = (trailing + leading) / 2
            
            origin.x = (alignment == .leading ? leading : alignment == .trailing ? trailing : center)
            
            for view in row {
                let viewSize = view.sizeThatFits(proposal)
                view.place(at: origin, proposal: proposal)
                origin.x += (viewSize.width + spacing)
            }
            
            origin.y += (row.maxHeight(proposal) + spacing)
        }
    }
 
    /// Generates rows of subviews based on the available width.
    ///
    /// - Parameters:
    ///   - maxWidth: The maximum width available for layout.
    ///   - proposal: The proposed size from the parent.
    ///   - subviews: The subviews to arrange.
    ///
    /// - Returns: A two-dimensional array representing rows of subviews.
    func generateRows(_ maxWidth: CGFloat, _ proposal: ProposedViewSize, _ subviews: Subviews) -> [[LayoutSubviews.Element]] {
        var row: [LayoutSubviews.Element] = []
        var rows: [[LayoutSubviews.Element]] = []
        var origin = CGRect.zero.origin
        
        for view in subviews {
            let viewSize = view.sizeThatFits(proposal)
            
            if (origin.x + viewSize.width + spacing) > maxWidth {
                rows.append(row)
                row.removeAll()
                origin.x = 0
                row.append(view)
                origin.x += (viewSize.width + spacing)
            } else {
                row.append(view)
                origin.x += (viewSize.width + spacing)
            }
        }
        
        if !row.isEmpty {
            rows.append(row)
            row.removeAll()
        }
        
        return rows
    }
}

@available(iOS 18.0, *)
fileprivate extension [LayoutSubviews.Element] {
    
    /// Returns the maximum height of the subviews for a given size proposal.
    ///
    /// - Parameter proposal: The proposed size used for measurement.
    /// - Returns: The maximum height among all subviews, or `0` if empty.
    func maxHeight(_ proposal: ProposedViewSize) -> CGFloat {
        return self.compactMap { view in
            return view.sizeThatFits(proposal).height
        }.max() ?? 0
    }
}
