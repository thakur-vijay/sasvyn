//
//  MyIcon.swift
//  SVSocialLinkKit
//
//  Created by Vijay Thakur on 31/08/26.
//

import SwiftUI

internal struct XIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.7875*width, y: 0.04688*height))
        path.addLine(to: CGPoint(x: 0.94088*width, y: 0.04688*height))
        path.addLine(to: CGPoint(x: 0.60587*width, y: 0.43075*height))
        path.addLine(to: CGPoint(x: width, y: 0.95313*height))
        path.addLine(to: CGPoint(x: 0.69144*width, y: 0.95313*height))
        path.addLine(to: CGPoint(x: 0.44975*width, y: 0.63625*height))
        path.addLine(to: CGPoint(x: 0.17319*width, y: 0.95313*height))
        path.addLine(to: CGPoint(x: 0.01975*width, y: 0.95313*height))
        path.addLine(to: CGPoint(x: 0.37806*width, y: 0.5425*height))
        path.addLine(to: CGPoint(x: 0, y: 0.04688*height))
        path.addLine(to: CGPoint(x: 0.31644*width, y: 0.04688*height))
        path.addLine(to: CGPoint(x: 0.53487*width, y: 0.33644*height))
        path.addLine(to: CGPoint(x: 0.78756*width, y: 0.04688*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.73375*width, y: 0.86113*height))
        path.addLine(to: CGPoint(x: 0.81875*width, y: 0.86113*height))
        path.addLine(to: CGPoint(x: 0.27019*width, y: 0.13406*height))
        path.addLine(to: CGPoint(x: 0.17906*width, y: 0.13406*height))
        path.closeSubpath()
        return path
    }
}
