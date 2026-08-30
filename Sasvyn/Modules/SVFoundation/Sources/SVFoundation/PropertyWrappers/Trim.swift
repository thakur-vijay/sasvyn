//
//  Trim.swift
//  SVFoundation
//
//  Created by Vijay Thakur on 29/08/26.
//

import Foundation

@propertyWrapper
public struct Trim: Sendable, Hashable{
    private var value: String

    public var wrappedValue: String {
        get { value }
        set { value = newValue.trimmingCharacters(in: .whitespacesAndNewlines) }
    }

    public init(wrappedValue: String) {
        self.value = wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
