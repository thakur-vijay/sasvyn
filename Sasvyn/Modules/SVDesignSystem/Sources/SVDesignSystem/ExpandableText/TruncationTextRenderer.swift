//
//  TruncationTextRenderer.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 17/08/26.
//

import SwiftUI

@available(iOS 18.0, *)
@Animatable
internal struct TruncationTextRenderer: TextRenderer {
    @AnimatableIgnored var length: Int
    @AnimatableIgnored var moreText: String
    var blurRadius: CGFloat
    var progress: CGFloat
    func draw(layout: Text.Layout, in ctx: inout GraphicsContext) {
        for (index, line) in layout.enumerated() {
            var copyContext = ctx
            if (index == length - 1){
                drawMoreTextAtEnd(line: line, context: &copyContext)
            }else {
                if index < length  || blurRadius.isZero{
                    copyContext.draw(line)
                }else {
                    drawLinesWithBlurEffect(index: index, layout: layout, context: &copyContext)
                }
            }
        }
    }
    
    func drawLinesWithBlurEffect(index: Int, layout: Text.Layout, context: inout GraphicsContext){
        let line = layout[index]
        let lineIndex = Double(index - length)
        let totalExtraLines = Double(layout.count - length)
        
        let lineStartProgress = lineIndex / max(1, totalExtraLines)
        let lineEndProgress = (lineIndex + 1) / max(1, totalExtraLines)
        
        let lineProgress = max(0, min(1, (progress - lineStartProgress) / (lineEndProgress - lineStartProgress)))
        context.opacity = lineProgress
        context.addFilter(.blur(radius: blurRadius - (blurRadius * lineProgress)))
        context.draw(line)
    }
    
    func drawMoreTextAtEnd(line: Text.Layout.Element, context: inout GraphicsContext){
        let runs = line.flatMap { $0 }
        let runsCount = runs.count
        let textCount = moreText.count
        
        for index in 0..<max(runsCount - textCount, 0){
            let run = runs[index]
            context.draw(run)
        }
        
        for index in max(runsCount - textCount, 0)..<runsCount {
            let run = runs[index]
            context.opacity = progress
            context.draw(run)
        }
        
        let textRunIndex = max(runsCount - textCount, 0)
        guard !runs.isEmpty else { return }
        let run = runs[textRunIndex]
        let typography = run.typographicBounds
        let fontSize: CGFloat = typography.ascent
        let font: UIFont = UIFont.systemFont(ofSize: fontSize)
        let spacing: CGFloat = NSString(string: moreText).size(withAttributes: [
            .font: font
        ]).width / 2
        let swiftUIText = Text(moreText)
            .font(Font(font))
            .foregroundStyle(.gray)
        let origin = CGPoint(
            x: typography.rect.minX + spacing,
            y: typography.rect.midY
        )
        context.opacity = 1 - progress
        context.draw(swiftUIText, at: origin )
    }
    
}
