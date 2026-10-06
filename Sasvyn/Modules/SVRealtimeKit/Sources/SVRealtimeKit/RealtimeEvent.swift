//
//  RealtimeEvent.swift
//  SVRealtimeKit
//
//  Created by Vijay Thakur on 06/10/26.
//

import Foundation

public enum RealtimeEvent: String, Sendable, Codable {
    
    case skillCreated = "skill.created"
    case skillUpdated = "skill.updated"
    case skillDeleted = "skill.deleted"
    
    case languageCreated = "language.created"
    case languageUpdated = "language.updated"
    case languageDeleted = "language.deleted"
    
    case projectCreated = "project.created"
    case projectUpdated = "project.updated"
    case projectDeleted = "project.deleted"
}
