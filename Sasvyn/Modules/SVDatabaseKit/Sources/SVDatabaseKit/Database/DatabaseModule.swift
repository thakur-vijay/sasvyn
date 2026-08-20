//
//  DatabaseModule.swift
//  SasvynDatabaseKit
//
//  Created by Vijay Thakur on 03/07/26.
//


import Foundation

public protocol DatabaseModule {

    static func register(
        on migrator: DatabaseMigrator
    )
}

