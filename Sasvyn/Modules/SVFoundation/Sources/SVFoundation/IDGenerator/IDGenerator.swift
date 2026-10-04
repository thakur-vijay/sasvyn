//
//  IDGenerator.swift
//  SVFoundation
//
//  Created by Vijay Thakur on 30/09/26.
//

import Foundation

public enum IDGenerator {

    public static func uuid() -> String {
        UUID().uuidString.lowercased()
    }
}
