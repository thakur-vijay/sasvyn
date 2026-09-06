//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import Foundation

public struct About: Identifiable, Hashable, Sendable{
    public var id: String { userId }
    public let userId: String
    public var content: String
    
    public init(userId: String, content: String) {
        self.userId = userId
        self.content = content
    }
}
