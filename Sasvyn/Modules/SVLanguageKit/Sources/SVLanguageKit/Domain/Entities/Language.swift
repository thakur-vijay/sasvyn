//
//  File.swift
//  SVLanguageKit
//
//  Created by Vijay Thakur on 30/08/26.
//

import Foundation

public struct Language: Identifiable, Codable, Hashable, Sendable {
    public var id: String { iso639_3 }
    public let code: String
    public let iso639_3: String
    public let name: String
    
    public init(code: String, iso639_3: String, name: String) {
        self.code = code
        self.iso639_3 = iso639_3
        self.name = name
    }
}
