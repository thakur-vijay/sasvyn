//
//  ValidatedString.swift
//  SVFoundation
//
//  Created by Vijay Thakur on 29/08/26.
//

import Foundation

@propertyWrapper
public struct Constrained: Sendable, Hashable {

    public enum Kind: Sendable {
        case integer
        case decimal
        case alphabetic
        case alphanumeric
    }

    private var value: String
    private let kind: Kind

    public var wrappedValue: String {
        get { value }
        set {
            value = Self.sanitize(newValue, kind: kind)
        }
    }

    public init(_ kind: Kind, wrappedValue: String = "") {
        self.kind = kind
        self.value = Self.sanitize(wrappedValue, kind: kind)
    }

    private static func sanitize(
        _ value: String,
        kind: Kind
    ) -> String {
        let value = value.trimmingCharacters(in: .whitespacesAndNewlines)

        switch kind {
        case .integer:
           return value.filter(\.isNumber)
        case .decimal:
            var result = ""
            var hasDecimal = false

            for character in value {
                if character.isNumber {
                    result.append(character)
                } else if character == "." && !hasDecimal {
                    result.append(character)
                    hasDecimal = true
                }
            }

            return result

        case .alphabetic:
            return value.filter(\.isLetter)

        case .alphanumeric:
            return value.filter { $0.isLetter || $0.isNumber }
        }
    }
}
