//
//  File.swift
//  SVFoundation
//
//  Created by Vijay Thakur on 31/08/26.
//

import Foundation

public extension URL {
    var isValid: Bool {
        guard
            let scheme = scheme?.lowercased(),
            let host = host?.lowercased(),
            !scheme.isEmpty,
            !host.isEmpty,
            scheme == "http" || scheme == "https",
            !host.contains("..")
        else {
            return false
        }

        if let port, !(1...65_535).contains(port) {
            return false
        }

        return true
    }
}
