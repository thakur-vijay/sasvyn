//
//  MyIcon.swift
//  SVSocialLinkKit
//
//  Created by Vijay Thakur on 31/08/26.
//

import SwiftUI

internal struct DribbleIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.5*width, y: 0))
        path.addCurve(to: CGPoint(x: 0, y: 0.5*height), control1: CGPoint(x: 0.224*width, y: 0), control2: CGPoint(x: 0, y: 0.224*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: height), control1: CGPoint(x: 0, y: 0.776*height), control2: CGPoint(x: 0.224*width, y: height))
        path.addCurve(to: CGPoint(x: width, y: 0.5*height), control1: CGPoint(x: 0.7755*width, y: height), control2: CGPoint(x: width, y: 0.776*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0), control1: CGPoint(x: width, y: 0.224*height), control2: CGPoint(x: 0.7755*width, y: 0))
        path.move(to: CGPoint(x: 0.83031*width, y: 0.23044*height))
        path.addCurve(to: CGPoint(x: 0.59219*width, y: 0.39856*height), control1: CGPoint(x: 0.82106*width, y: 0.24244*height), control2: CGPoint(x: 0.74944*width, y: 0.33463*height))
        path.addCurve(to: CGPoint(x: 0.62037*width, y: 0.46044*height), control1: CGPoint(x: 0.60194*width, y: 0.41869*height), control2: CGPoint(x: 0.61169*width, y: 0.43981*height))
        path.addCurve(to: CGPoint(x: 0.62962*width, y: 0.48263*height), control1: CGPoint(x: 0.62362*width, y: 0.468*height), control2: CGPoint(x: 0.62637*width, y: 0.47563*height))
        path.addCurve(to: CGPoint(x: 0.92681*width, y: 0.49619*height), control1: CGPoint(x: 0.77169*width, y: 0.46475*height), control2: CGPoint(x: 0.91269*width, y: 0.4935*height))
        path.addCurve(to: CGPoint(x: 0.83025*width, y: 0.2305*height), control1: CGPoint(x: 0.92588*width, y: 0.3992*height), control2: CGPoint(x: 0.89181*width, y: 0.30545*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.5*width, y: 0.07375*height))
        path.addCurve(to: CGPoint(x: 0.39969*width, y: 0.08513*height), control1: CGPoint(x: 0.46624*width, y: 0.07366*height), control2: CGPoint(x: 0.43257*width, y: 0.07748*height))
        path.addCurve(to: CGPoint(x: 0.55913*width, y: 0.33513*height), control1: CGPoint(x: 0.41163*width, y: 0.10137*height), control2: CGPoint(x: 0.48913*width, y: 0.20663*height))
        path.addCurve(to: CGPoint(x: 0.78313*width, y: 0.18112*height), control1: CGPoint(x: 0.71094*width, y: 0.27819*height), control2: CGPoint(x: 0.7755*width, y: 0.192*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0.07375*height), control1: CGPoint(x: 0.70769*width, y: 0.11438*height), control2: CGPoint(x: 0.60844*width, y: 0.07375*height))
        path.move(to: CGPoint(x: 0.31831*width, y: 0.11394*height))
        path.addCurve(to: CGPoint(x: 0.08187*width, y: 0.41269*height), control1: CGPoint(x: 0.19721*width, y: 0.17119*height), control2: CGPoint(x: 0.10977*width, y: 0.28168*height))
        path.addCurve(to: CGPoint(x: 0.47669*width, y: 0.36062*height), control1: CGPoint(x: 0.10087*width, y: 0.41269*height), control2: CGPoint(x: 0.27712*width, y: 0.41375*height))
        path.addCurve(to: CGPoint(x: 0.31831*width, y: 0.11388*height), control1: CGPoint(x: 0.42843*width, y: 0.27555*height), control2: CGPoint(x: 0.37555*width, y: 0.19318*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.07269*width, y: 0.50056*height))
        path.addCurve(to: CGPoint(x: 0.18219*width, y: 0.78581*height), control1: CGPoint(x: 0.07268*width, y: 0.60591*height), control2: CGPoint(x: 0.11169*width, y: 0.70753*height))
        path.addCurve(to: CGPoint(x: 0.52925*width, y: 0.50431*height), control1: CGPoint(x: 0.192*width, y: 0.7695*height), control2: CGPoint(x: 0.30912*width, y: 0.57537*height))
        path.addLine(to: CGPoint(x: 0.54612*width, y: 0.49944*height))
        path.addCurve(to: CGPoint(x: 0.51144*width, y: 0.42681*height), control1: CGPoint(x: 0.53525*width, y: 0.47506*height), control2: CGPoint(x: 0.52387*width, y: 0.45062*height))
        path.addCurve(to: CGPoint(x: 0.07269*width, y: 0.4875*height), control1: CGPoint(x: 0.29831*width, y: 0.49081*height), control2: CGPoint(x: 0.09112*width, y: 0.48812*height))
        path.addLine(to: CGPoint(x: 0.07269*width, y: 0.50062*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.5*width, y: 0.92731*height))
        path.addCurve(to: CGPoint(x: 0.667*width, y: 0.89319*height), control1: CGPoint(x: 0.55742*width, y: 0.92751*height), control2: CGPoint(x: 0.61426*width, y: 0.91589*height))
        path.addCurve(to: CGPoint(x: 0.57594*width, y: 0.56944*height), control1: CGPoint(x: 0.647*width, y: 0.78262*height), control2: CGPoint(x: 0.61651*width, y: 0.67422*height))
        path.addCurve(to: CGPoint(x: 0.57319*width, y: 0.5705*height), control1: CGPoint(x: 0.57481*width, y: 0.56994*height), control2: CGPoint(x: 0.57431*width, y: 0.56994*height))
        path.addCurve(to: CGPoint(x: 0.23812*width, y: 0.83731*height), control1: CGPoint(x: 0.33244*width, y: 0.65456*height), control2: CGPoint(x: 0.24562*width, y: 0.82156*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0.92731*height), control1: CGPoint(x: 0.31292*width, y: 0.89571*height), control2: CGPoint(x: 0.40511*width, y: 0.92739*height))
        path.move(to: CGPoint(x: 0.73806*width, y: 0.85413*height))
        path.addCurve(to: CGPoint(x: 0.92081*width, y: 0.56831*height), control1: CGPoint(x: 0.83618*width, y: 0.78851*height), control2: CGPoint(x: 0.90243*width, y: 0.6849*height))
        path.addCurve(to: CGPoint(x: 0.65513*width, y: 0.54988*height), control1: CGPoint(x: 0.90619*width, y: 0.56344*height), control2: CGPoint(x: 0.78906*width, y: 0.52875*height))
        path.addCurve(to: CGPoint(x: 0.73813*width, y: 0.85413*height), control1: CGPoint(x: 0.71094*width, y: 0.70338*height), control2: CGPoint(x: 0.73375*width, y: 0.82806*height))
        path.closeSubpath()
        return path
    }
}
