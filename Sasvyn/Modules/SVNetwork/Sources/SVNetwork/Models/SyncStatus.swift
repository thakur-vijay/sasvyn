//
//  SyncStatus.swift
//  SVNetwork
//
//  Created by Vijay Thakur on 23/09/26.
//


public enum SyncStatus: String, Codable, Hashable, Sendable {
    case synced
    case pending
    case failed
}