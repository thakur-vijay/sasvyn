//
//  MyIcon.swift
//  SVSocialLinkKit
//
//  Created by Vijay Thakur on 31/08/26.
//

import SwiftUI

internal struct LinkedInIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0, y: 0.07162*height))
        path.addCurve(to: CGPoint(x: 0.07344*width, y: 0), control1: CGPoint(x: 0, y: 0.03206*height), control2: CGPoint(x: 0.03288*width, y: 0))
        path.addLine(to: CGPoint(x: 0.92656*width, y: 0))
        path.addCurve(to: CGPoint(x: width, y: 0.07162*height), control1: CGPoint(x: 0.96713*width, y: 0), control2: CGPoint(x: width, y: 0.03206*height))
        path.addLine(to: CGPoint(x: width, y: 0.92837*height))
        path.addCurve(to: CGPoint(x: 0.92656*width, y: height), control1: CGPoint(x: width, y: 0.96794*height), control2: CGPoint(x: 0.96713*width, y: height))
        path.addLine(to: CGPoint(x: 0.07344*width, y: height))
        path.addCurve(to: CGPoint(x: 0, y: 0.92837*height), control1: CGPoint(x: 0.03288*width, y: height), control2: CGPoint(x: 0, y: 0.96794*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.30894*width, y: 0.83712*height))
        path.addLine(to: CGPoint(x: 0.30894*width, y: 0.38556*height))
        path.addLine(to: CGPoint(x: 0.15887*width, y: 0.38556*height))
        path.addLine(to: CGPoint(x: 0.15887*width, y: 0.83712*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.23394*width, y: 0.32387*height))
        path.addCurve(to: CGPoint(x: 0.31881*width, y: 0.24587*height), control1: CGPoint(x: 0.28625*width, y: 0.32387*height), control2: CGPoint(x: 0.31881*width, y: 0.28925*height))
        path.addCurve(to: CGPoint(x: 0.23494*width, y: 0.16787*height), control1: CGPoint(x: 0.31787*width, y: 0.20156*height), control2: CGPoint(x: 0.28631*width, y: 0.16787*height))
        path.addCurve(to: CGPoint(x: 0.15*width, y: 0.24588*height), control1: CGPoint(x: 0.18356*width, y: 0.16787*height), control2: CGPoint(x: 0.15*width, y: 0.20162*height))
        path.addCurve(to: CGPoint(x: 0.23294*width, y: 0.32388*height), control1: CGPoint(x: 0.15*width, y: 0.28925*height), control2: CGPoint(x: 0.18256*width, y: 0.32388*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.54069*width, y: 0.83712*height))
        path.addLine(to: CGPoint(x: 0.54069*width, y: 0.58494*height))
        path.addCurve(to: CGPoint(x: 0.54569*width, y: 0.54831*height), control1: CGPoint(x: 0.54069*width, y: 0.57144*height), control2: CGPoint(x: 0.54169*width, y: 0.55794*height))
        path.addCurve(to: CGPoint(x: 0.62269*width, y: 0.49344*height), control1: CGPoint(x: 0.5565*width, y: 0.52138*height), control2: CGPoint(x: 0.58119*width, y: 0.49344*height))
        path.addCurve(to: CGPoint(x: 0.69869*width, y: 0.59556*height), control1: CGPoint(x: 0.677*width, y: 0.49344*height), control2: CGPoint(x: 0.69869*width, y: 0.53481*height))
        path.addLine(to: CGPoint(x: 0.69869*width, y: 0.83713*height))
        path.addLine(to: CGPoint(x: 0.84875*width, y: 0.83713*height))
        path.addLine(to: CGPoint(x: 0.84875*width, y: 0.57813*height))
        path.addCurve(to: CGPoint(x: 0.676*width, y: 0.37488*height), control1: CGPoint(x: 0.84875*width, y: 0.43937*height), control2: CGPoint(x: 0.77475*width, y: 0.37488*height))
        path.addCurve(to: CGPoint(x: 0.54069*width, y: 0.44944*height), control1: CGPoint(x: 0.59637*width, y: 0.37488*height), control2: CGPoint(x: 0.56069*width, y: 0.41863*height))
        path.addLine(to: CGPoint(x: 0.54069*width, y: 0.451*height))
        path.addLine(to: CGPoint(x: 0.53969*width, y: 0.451*height))
        path.addLine(to: CGPoint(x: 0.54069*width, y: 0.44944*height))
        path.addLine(to: CGPoint(x: 0.54069*width, y: 0.38556*height))
        path.addLine(to: CGPoint(x: 0.39069*width, y: 0.38556*height))
        path.addCurve(to: CGPoint(x: 0.39069*width, y: 0.83712*height), control1: CGPoint(x: 0.39256*width, y: 0.42794*height), control2: CGPoint(x: 0.39069*width, y: 0.83712*height))
        path.closeSubpath()
        return path
    }
}
