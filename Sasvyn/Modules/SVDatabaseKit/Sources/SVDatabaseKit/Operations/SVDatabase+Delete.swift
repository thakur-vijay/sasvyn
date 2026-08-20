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
