//
//  File.swift
//  SVDatabaseKit
//
//  Created by Vijay Thakur on 20/08/26.
//

import GRDB

public extension SVDatabase {

    func alterTable(
        _ name: String,
        body: (SVTableAlterationBuilder) -> Void
    ) throws {
        try db.alter(
            table: name
        ) { table in
            let builder = SVTableAlterationBuilder(table: table)
            body(builder)
        }
    }
}
