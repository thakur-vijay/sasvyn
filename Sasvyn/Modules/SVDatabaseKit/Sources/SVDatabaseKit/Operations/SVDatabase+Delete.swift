//
//  SwiftUIView.swift
//  SVDatabaseKit
//
//  Created by Vijay Thakur on 27/06/26.
//

import GRDB

public extension SVDatabase {

    @discardableResult
    func delete<Record: SVPersistableRecord>(
        _ record: Record.Type,
        key: some SVDatabaseValueConvertible
    ) throws -> Bool {
        try record.deleteOne(db, key: key)
    }
}

public extension SVDatabase {

    @discardableResult
    func delete<Record: SVFetchableRecord & SVPersistableRecord>(
        _ record: Record.Type,
        where filter: SVDatabaseFilter
    ) throws -> Int {
        var request = record.all()

        request = request.filter(filter.expression)

        return try request.deleteAll(db)
    }
}
