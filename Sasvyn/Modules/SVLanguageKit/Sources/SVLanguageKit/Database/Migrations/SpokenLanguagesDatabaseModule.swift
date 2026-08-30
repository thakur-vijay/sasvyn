//
//  ChatListsDatabaseModule.swift
//  VynkChatLists
//
//  Created by Vijay Thakur on 03/07/26.
//

import Foundation
import SVDatabaseKit

public enum SpokenLanguagesDatabaseModule: DatabaseModule {

    public static func register(
        on migrator: DatabaseMigrator
    ) {
        migrator.add(CreateSpokenLanguagesMigration())
    }
}
