//
//  MockupsViewType.swift
//  iOSMockupKit
//
//  Created by Vijay Thakur on 24/08/26.
//

import Foundation

public enum ImageContentMode: String {
    case fill
    case fit
    
    var padding: CGFloat {
        switch self {
        case .fill: 0
        case .fit: 20
        }
    }
}
