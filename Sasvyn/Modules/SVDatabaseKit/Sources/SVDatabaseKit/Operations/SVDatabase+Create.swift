//
//  SwiftUIView.swift
//  SVDatabaseKit
//
//  Created by Vijay Thakur on 27/06/26.
//

import GRDB

public extension SVDatabase {
    
    func createTable(
        _ name: String,
        ifNotExists: Bool = false,
        body: (SVTableBuilder) -> Void
    ) throws {
        try db.create(
            table: name,
            ifNotExists: ifNotExists
        ) { table in
            let builder = SVTableBuilder(table: table)
            body(builder)
        }
    }
}
