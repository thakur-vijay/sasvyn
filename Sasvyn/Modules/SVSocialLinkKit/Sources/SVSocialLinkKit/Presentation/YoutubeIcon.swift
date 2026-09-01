//
//  MyIcon.swift
//  SVSocialLinkKit
//
//  Created by Vijay Thakur on 31/08/26.
//

import SwiftUI

internal struct YoutubeIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.50319*width, y: 0.12494*height))
        path.addLine(to: CGPoint(x: 0.50875*width, y: 0.12494*height))
        path.addCurve(to: CGPoint(x: 0.89063*width, y: 0.14588*height), control1: CGPoint(x: 0.56012*width, y: 0.12513*height), control2: CGPoint(x: 0.82044*width, y: 0.127*height))
        path.addCurve(to: CGPoint(x: 0.97906*width, y: 0.23462*height), control1: CGPoint(x: 0.93381*width, y: 0.1576*height), control2: CGPoint(x: 0.96749*width, y: 0.1914*height))
        path.addCurve(to: CGPoint(x: 0.99281*width, y: 0.32225*height), control1: CGPoint(x: 0.98538*width, y: 0.25838*height), control2: CGPoint(x: 0.98981*width, y: 0.28981*height))
        path.addLine(to: CGPoint(x: 0.99344*width, y: 0.32875*height))
        path.addLine(to: CGPoint(x: 0.99481*width, y: 0.345*height))
        path.addLine(to: CGPoint(x: 0.99531*width, y: 0.3515*height))
        path.addCurve(to: CGPoint(x: 0.99994*width, y: 0.47381*height), control1: CGPoint(x: 0.99937*width, y: 0.40862*height), control2: CGPoint(x: 0.99987*width, y: 0.46213*height))
        path.addLine(to: CGPoint(x: 0.99994*width, y: 0.4785*height))
        path.addCurve(to: CGPoint(x: 0.99481*width, y: 0.60725*height), control1: CGPoint(x: 0.99987*width, y: 0.49062*height), control2: CGPoint(x: 0.99931*width, y: 0.54775*height))
        path.addLine(to: CGPoint(x: 0.99431*width, y: 0.61381*height))
        path.addLine(to: CGPoint(x: 0.99375*width, y: 0.62031*height))
        path.addCurve(to: CGPoint(x: 0.97906*width, y: 0.71769*height), control1: CGPoint(x: 0.99062*width, y: 0.65606*height), control2: CGPoint(x: 0.986*width, y: 0.69156*height))
        path.addCurve(to: CGPoint(x: 0.89063*width, y: 0.80644*height), control1: CGPoint(x: 0.96749*width, y: 0.76091*height), control2: CGPoint(x: 0.93381*width, y: 0.79471*height))
        path.addCurve(to: CGPoint(x: 0.50438*width, y: 0.82737*height), control1: CGPoint(x: 0.81812*width, y: 0.82594*height), control2: CGPoint(x: 0.54256*width, y: 0.82731*height))
        path.addLine(to: CGPoint(x: 0.4955*width, y: 0.82737*height))
        path.addCurve(to: CGPoint(x: 0.31256*width, y: 0.82412*height), control1: CGPoint(x: 0.47619*width, y: 0.82737*height), control2: CGPoint(x: 0.39631*width, y: 0.827*height))
        path.addLine(to: CGPoint(x: 0.30194*width, y: 0.82375*height))
        path.addLine(to: CGPoint(x: 0.2965*width, y: 0.8235*height))
        path.addLine(to: CGPoint(x: 0.28581*width, y: 0.82306*height))
        path.addLine(to: CGPoint(x: 0.27512*width, y: 0.82263*height))
        path.addCurve(to: CGPoint(x: 0.10925*width, y: 0.80638*height), control1: CGPoint(x: 0.20575*width, y: 0.81956*height), control2: CGPoint(x: 0.13969*width, y: 0.81463*height))
        path.addCurve(to: CGPoint(x: 0.02081*width, y: 0.71769*height), control1: CGPoint(x: 0.06609*width, y: 0.79466*height), control2: CGPoint(x: 0.0324*width, y: 0.76089*height))
        path.addCurve(to: CGPoint(x: 0.00612*width, y: 0.62031*height), control1: CGPoint(x: 0.01387*width, y: 0.69163*height), control2: CGPoint(x: 0.00925*width, y: 0.65606*height))
        path.addLine(to: CGPoint(x: 0.00562*width, y: 0.61375*height))
        path.addLine(to: CGPoint(x: 0.00512*width, y: 0.60725*height))
        path.addCurve(to: CGPoint(x: 0, y: 0.48*height), control1: CGPoint(x: 0.00202*width, y: 0.5649*height), control2: CGPoint(x: 0.00031*width, y: 0.52246*height))
        path.addLine(to: CGPoint(x: 0, y: 0.47231*height))
        path.addCurve(to: CGPoint(x: 0.004*width, y: 0.36119*height), control1: CGPoint(x: 0.00013*width, y: 0.45887*height), control2: CGPoint(x: 0.00063*width, y: 0.41244*height))
        path.addLine(to: CGPoint(x: 0.00444*width, y: 0.35475*height))
        path.addLine(to: CGPoint(x: 0.00463*width, y: 0.3515*height))
        path.addLine(to: CGPoint(x: 0.00513*width, y: 0.345*height))
        path.addLine(to: CGPoint(x: 0.0065*width, y: 0.32875*height))
        path.addLine(to: CGPoint(x: 0.00713*width, y: 0.32225*height))
        path.addCurve(to: CGPoint(x: 0.02088*width, y: 0.23463*height), control1: CGPoint(x: 0.01013*width, y: 0.28981*height), control2: CGPoint(x: 0.01456*width, y: 0.25831*height))
        path.addCurve(to: CGPoint(x: 0.10931*width, y: 0.14588*height), control1: CGPoint(x: 0.03245*width, y: 0.1914*height), control2: CGPoint(x: 0.06613*width, y: 0.1576*height))
        path.addCurve(to: CGPoint(x: 0.27519*width, y: 0.12963*height), control1: CGPoint(x: 0.13975*width, y: 0.13775*height), control2: CGPoint(x: 0.20581*width, y: 0.13275*height))
        path.addLine(to: CGPoint(x: 0.28581*width, y: 0.12919*height))
        path.addLine(to: CGPoint(x: 0.29656*width, y: 0.12881*height))
        path.addLine(to: CGPoint(x: 0.30194*width, y: 0.12863*height))
        path.addLine(to: CGPoint(x: 0.31263*width, y: 0.12819*height))
        path.addCurve(to: CGPoint(x: 0.49112*width, y: 0.125*height), control1: CGPoint(x: 0.37211*width, y: 0.12628*height), control2: CGPoint(x: 0.43161*width, y: 0.12521*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.4*width, y: 0.32556*height))
        path.addLine(to: CGPoint(x: 0.4*width, y: 0.62669*height))
        path.addLine(to: CGPoint(x: 0.65981*width, y: 0.47619*height))
        path.closeSubpath()
        return path
    }
}
