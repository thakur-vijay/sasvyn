//
//  MyIcon.swift
//  SVSocialLinkKit
//
//  Created by Vijay Thakur on 31/08/26.
//

import SwiftUI

internal struct GithubIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.5*width, y: 0))
        path.addCurve(to: CGPoint(x: width, y: 0.5*height), control1: CGPoint(x: 0.77625*width, y: 0), control2: CGPoint(x: width, y: 0.22375*height))
        path.addCurve(to: CGPoint(x: 0.65937*width, y: 0.97438*height), control1: CGPoint(x: width, y: 0.71483*height), control2: CGPoint(x: 0.86294*width, y: 0.90571*height))
        path.addCurve(to: CGPoint(x: 0.625*width, y: 0.95063*height), control1: CGPoint(x: 0.63437*width, y: 0.97938*height), control2: CGPoint(x: 0.625*width, y: 0.96375*height))
        path.addCurve(to: CGPoint(x: 0.62562*width, y: 0.81313*height), control1: CGPoint(x: 0.625*width, y: 0.93375*height), control2: CGPoint(x: 0.62562*width, y: 0.88*height))
        path.addCurve(to: CGPoint(x: 0.59187*width, y: 0.72063*height), control1: CGPoint(x: 0.62562*width, y: 0.76625*height), control2: CGPoint(x: 0.61*width, y: 0.73625*height))
        path.addCurve(to: CGPoint(x: 0.82*width, y: 0.47375*height), control1: CGPoint(x: 0.70313*width, y: 0.70813*height), control2: CGPoint(x: 0.82*width, y: 0.66563*height))
        path.addCurve(to: CGPoint(x: 0.76875*width, y: 0.33937*height), control1: CGPoint(x: 0.82*width, y: 0.41875*height), control2: CGPoint(x: 0.80062*width, y: 0.37438*height))
        path.addCurve(to: CGPoint(x: 0.76375*width, y: 0.20688*height), control1: CGPoint(x: 0.77375*width, y: 0.32688*height), control2: CGPoint(x: 0.79125*width, y: 0.27563*height))
        path.addCurve(to: CGPoint(x: 0.62625*width, y: 0.25812*height), control1: CGPoint(x: 0.76375*width, y: 0.20688*height), control2: CGPoint(x: 0.72187*width, y: 0.19312*height))
        path.addCurve(to: CGPoint(x: 0.50125*width, y: 0.24125*height), control1: CGPoint(x: 0.58625*width, y: 0.24687*height), control2: CGPoint(x: 0.54375*width, y: 0.24125*height))
        path.addCurve(to: CGPoint(x: 0.37625*width, y: 0.25812*height), control1: CGPoint(x: 0.45875*width, y: 0.24125*height), control2: CGPoint(x: 0.41625*width, y: 0.24687*height))
        path.addCurve(to: CGPoint(x: 0.23875*width, y: 0.20687*height), control1: CGPoint(x: 0.28063*width, y: 0.19375*height), control2: CGPoint(x: 0.23875*width, y: 0.20687*height))
        path.addCurve(to: CGPoint(x: 0.23375*width, y: 0.33937*height), control1: CGPoint(x: 0.21125*width, y: 0.27563*height), control2: CGPoint(x: 0.22875*width, y: 0.32687*height))
        path.addCurve(to: CGPoint(x: 0.1825*width, y: 0.47375*height), control1: CGPoint(x: 0.20188*width, y: 0.37437*height), control2: CGPoint(x: 0.1825*width, y: 0.41937*height))
        path.addCurve(to: CGPoint(x: 0.41*width, y: 0.72062*height), control1: CGPoint(x: 0.1825*width, y: 0.665*height), control2: CGPoint(x: 0.29875*width, y: 0.70813*height))
        path.addCurve(to: CGPoint(x: 0.37813*width, y: 0.7875*height), control1: CGPoint(x: 0.39563*width, y: 0.73313*height), control2: CGPoint(x: 0.3825*width, y: 0.755*height))
        path.addCurve(to: CGPoint(x: 0.2325*width, y: 0.74625*height), control1: CGPoint(x: 0.34937*width, y: 0.80062*height), control2: CGPoint(x: 0.2775*width, y: 0.82187*height))
        path.addCurve(to: CGPoint(x: 0.15563*width, y: 0.695*height), control1: CGPoint(x: 0.22313*width, y: 0.73125*height), control2: CGPoint(x: 0.195*width, y: 0.69437*height))
        path.addCurve(to: CGPoint(x: 0.15625*width, y: 0.72812*height), control1: CGPoint(x: 0.11375*width, y: 0.69562*height), control2: CGPoint(x: 0.13875*width, y: 0.71875*height))
        path.addCurve(to: CGPoint(x: 0.2075*width, y: 0.79875*height), control1: CGPoint(x: 0.1775*width, y: 0.74*height), control2: CGPoint(x: 0.20187*width, y: 0.78437*height))
        path.addCurve(to: CGPoint(x: 0.37562*width, y: 0.8575*height), control1: CGPoint(x: 0.2175*width, y: 0.82687*height), control2: CGPoint(x: 0.25*width, y: 0.88062*height))
        path.addCurve(to: CGPoint(x: 0.37625*width, y: 0.95062*height), control1: CGPoint(x: 0.37562*width, y: 0.89937*height), control2: CGPoint(x: 0.37625*width, y: 0.93875*height))
        path.addCurve(to: CGPoint(x: 0.34187*width, y: 0.97437*height), control1: CGPoint(x: 0.37625*width, y: 0.96375*height), control2: CGPoint(x: 0.36688*width, y: 0.97875*height))
        path.addCurve(to: CGPoint(x: 0, y: 0.5*height), control1: CGPoint(x: 0.14313*width, y: 0.90813*height), control2: CGPoint(x: 0, y: 0.72125*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0), control1: CGPoint(x: 0, y: 0.22375*height), control2: CGPoint(x: 0.22375*width, y: 0))
        return path
    }
}
