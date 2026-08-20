//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 16/08/26.
//

import Foundation

public enum ProjectMode: Sendable{
    case create
    case edit
    case view
    
    var isEditable: Bool {
        switch self {
        case .create, .edit: true
        case .view: false
        }
    }
}
