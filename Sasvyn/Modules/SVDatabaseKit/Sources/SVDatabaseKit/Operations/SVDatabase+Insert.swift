//
//  SwiftUIView.swift
//  SVDatabaseKit
//
//  Created by Vijay Thakur on 27/06/26.
//

import GRDB

public extension SVDatabase {
    func insert<Record: SVPersistableRecord>(
        _ record: Record
    ) throws {
        try record.insert(db)
    }

    func insertIgnoringConflict<Record: SVPersistableRecord>(
        _ record: Record
    ) throws {
        try record.insert(db, onConflict: .ignore)
    }
    
    func insert<Record: SVPersistableRecord>(
        _ records: [Record]
    ) throws {
        for record in records {
            try record.insert(db)
        }
    }

    func insertIgnoringConflict<Record: SVPersistableRecord>(
        _ records: [Record]
    ) throws {
        for record in records {
            try record.insert(db, onConflict: .ignore)
        }
    }
}
