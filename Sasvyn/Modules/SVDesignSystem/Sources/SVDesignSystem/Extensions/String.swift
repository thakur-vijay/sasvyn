//
//  File.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public extension String {
    
    var isEmptyString: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isNotEmpty: Bool {
        !isEmptyString
    }
}
