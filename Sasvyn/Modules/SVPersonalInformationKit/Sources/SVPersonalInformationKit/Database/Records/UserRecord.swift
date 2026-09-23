//
//  ChatListRecord.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//


import Foundation
import SVDatabaseKit
import SVNetwork

struct UserRecord: Codable, SVFetchableRecord, SVPersistableRecord{
    
    static let databaseTableName: String = "users"
    
    let id: String
    
    let appleId: String
    
    let fullName: String
    
    let email: String
    
    let dateOfBirth: Date?
    
    let imageLocalPath: String?
    
    let imageUrl: String?
    
    let profileSyncStatus: SyncStatus
    
    let imageSyncStatus: SyncStatus
    
    let createdAt: Date
    
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        
        case id, email
        case appleId = "apple_id"
        case fullName = "full_name"
        case dateOfBirth = "date_of_birth"
        case imageLocalPath = "image_local_path"
        case imageUrl = "image_url"
        case profileSyncStatus = "profile_sync_status"
        case imageSyncStatus = "image_sync_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        
    }
    
}

extension UserRecord {
    nonisolated enum ColumnNames {
        static let id = SVColumnName("id")
        static let appleId = SVColumnName("apple_id")
        static let fullName = SVColumnName("full_name")
        static let email = SVColumnName("email")
        static let dateOfBirth = SVColumnName("date_of_birth")
        static let imageLocalPath = SVColumnName("image_local_path")
        static let imageUrl = SVColumnName("image_url")
        static let profileSyncStatus = SVColumnName("profile_sync_status")
        static let imageSyncStatus = SVColumnName("image_sync_status")
        static let createdAt = SVColumnName("created_at")
        static let updatedAt = SVColumnName("updated_at")
    }
}

extension UserRecord {
    
    nonisolated enum Columns {
        
        static let id = SVColumn("id")
        static let appleId = SVColumn("apple_id")
        static let fullName = SVColumn("full_name")
        static let email = SVColumn("email")
        static let dateOfBirth = SVColumn("date_of_birth")
        static let imageLocalPath = SVColumn("image_local_path")
        static let imageUrl = SVColumn("image_url")
        static let profileSyncStatus = SVColumn("profile_sync_status")
        static let imageSyncStatus = SVColumn("image_sync_status")
        static let createdAt = SVColumn("created_at")
        static let updatedAt = SVColumn("updated_at")
        
    }
    
}
