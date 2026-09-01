//
//  MyIcon.swift
//  SVSocialLinkKit
//
//  Created by Vijay Thakur on 31/08/26.
//

import SwiftUI

internal struct MediumIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.56406*width, y: 0.5*height))
        path.addCurve(to: CGPoint(x: 0.282*width, y: 0.78125*height), control1: CGPoint(x: 0.56406*width, y: 0.65531*height), control2: CGPoint(x: 0.43781*width, y: 0.78125*height))
        path.addCurve(to: CGPoint(x: 0.08275*width, y: 0.69903*height), control1: CGPoint(x: 0.20731*width, y: 0.78135*height), control2: CGPoint(x: 0.13564*width, y: 0.75177*height))
        path.addCurve(to: CGPoint(x: 0, y: 0.5*height), control1: CGPoint(x: 0.02987*width, y: 0.64628*height), control2: CGPoint(x: 0.0001*width, y: 0.57469*height))
        path.addCurve(to: CGPoint(x: 0.282*width, y: 0.21875*height), control1: CGPoint(x: 0, y: 0.34462*height), control2: CGPoint(x: 0.12625*width, y: 0.21875*height))
        path.addCurve(to: CGPoint(x: 0.48129*width, y: 0.30095*height), control1: CGPoint(x: 0.3567*width, y: 0.21863*height), control2: CGPoint(x: 0.42839*width, y: 0.2482*height))
        path.addCurve(to: CGPoint(x: 0.56406*width, y: 0.5*height), control1: CGPoint(x: 0.53419*width, y: 0.3537*height), control2: CGPoint(x: 0.56396*width, y: 0.4253*height))
        path.move(to: CGPoint(x: 0.87344*width, y: 0.5*height))
        path.addCurve(to: CGPoint(x: 0.73244*width, y: 0.76475*height), control1: CGPoint(x: 0.87344*width, y: 0.64625*height), control2: CGPoint(x: 0.81031*width, y: 0.76475*height))
        path.addCurve(to: CGPoint(x: 0.59144*width, y: 0.5*height), control1: CGPoint(x: 0.65456*width, y: 0.76475*height), control2: CGPoint(x: 0.59144*width, y: 0.64619*height))
        path.addCurve(to: CGPoint(x: 0.73244*width, y: 0.23525*height), control1: CGPoint(x: 0.59144*width, y: 0.35375*height), control2: CGPoint(x: 0.65456*width, y: 0.23525*height))
        path.addCurve(to: CGPoint(x: 0.87344*width, y: 0.5*height), control1: CGPoint(x: 0.81031*width, y: 0.23525*height), control2: CGPoint(x: 0.87344*width, y: 0.35381*height))
        path.move(to: CGPoint(x: width, y: 0.5*height))
        path.addCurve(to: CGPoint(x: 0.95037*width, y: 0.73719*height), control1: CGPoint(x: width, y: 0.631*height), control2: CGPoint(x: 0.97781*width, y: 0.73719*height))
        path.addCurve(to: CGPoint(x: 0.90081*width, y: 0.5*height), control1: CGPoint(x: 0.923*width, y: 0.73719*height), control2: CGPoint(x: 0.90081*width, y: 0.63094*height))
        path.addCurve(to: CGPoint(x: 0.95044*width, y: 0.26281*height), control1: CGPoint(x: 0.90081*width, y: 0.369*height), control2: CGPoint(x: 0.923*width, y: 0.26281*height))
        path.addCurve(to: CGPoint(x: width, y: 0.5*height), control1: CGPoint(x: 0.97781*width, y: 0.26281*height), control2: CGPoint(x: width, y: 0.369*height))
        return path
    }
}
