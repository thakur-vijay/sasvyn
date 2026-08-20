//
//  SwiftUIView.swift
//  SVDatabaseKit
//
//  Created by Vijay Thakur on 27/06/26.
//

import GRDB

public extension SVDatabase {
    func execute(
        sql: String,
        arguments: [SVDatabaseValue] = []
    ) throws {
        try db.execute(
            sql: sql,
            arguments: StatementArguments(
                arguments.map(\.databaseValue)
            )
        )
    }
}
