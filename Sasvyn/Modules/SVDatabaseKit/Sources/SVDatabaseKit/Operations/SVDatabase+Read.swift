//
//  SwiftUIView.swift
//  SVDatabaseKit
//
//  Created by Vijay Thakur on 27/06/26.
//

import GRDB

public extension SVDatabase {

    func fetchAll<Record: SVFetchableRecord & SVTableRecord>(
        _ record: Record.Type,
        filters: [SVDatabaseFilter] = [],
        sorting: [SVDatabaseSort] = []
    ) throws -> [Record] {

        var request = record.all()

        for filter in filters {
            request = request.filter(filter.expression)
        }

        for sort in sorting {
            request = request.order(sort.ordering)
        }

        return try request.fetchAll(db)
    }
    
    func fetchValues<Value: DatabaseValueConvertible>(
        of type: Value.Type,
        from record: (some SVTableRecord).Type,
        column: SVColumnName
    ) throws -> [Value] {

        try Value.fetchAll(
            db,
            record.select(
                SVColumn(column.rawValue)
            )
        )
    }
    
    func fetchMax<Value: DatabaseValueConvertible>(
        _ type: Value.Type,
        column: SVColumnName,
        from table: String,
        filters: [SVDatabaseFilter] = []
    ) throws -> Value? {

        var sql = """
        SELECT MAX(\(column.rawValue))
        FROM \(table)
        """

        var arguments: [SVDatabaseValue] = []

        if !filters.isEmpty {

            sql += " WHERE "

            sql += filters
                .enumerated()
                .map { index, filter in

                    switch filter {

                    case .equals(let column, _):

                        return "\(column.rawValue) = ?"

                    default:
                        fatalError("Not implemented")

                    }

                }
                .joined(separator: " AND ")

            for filter in filters {

                switch filter {

                case .equals(_, let value):
                    arguments.append(value)

                default:
                    break
                }

            }

        }

        return try Value.fetchOne(
            db,
            sql: sql,
            arguments: StatementArguments(
                arguments.map(\.databaseValue)
            )
        )
    }
    
    func fetchOne<Record: SVFetchableRecord & SVTableRecord>(
        _ record: Record.Type,
        filters: [SVDatabaseFilter] = []
    ) throws -> Record? {

        var request = record.all()

        for filter in filters {
            request = request.filter(filter.expression)
        }

        return try request.fetchOne(db)
    }
    
    func fetchOne<Record: FetchableRecord>(
        _ record: Record.Type,
        sql: String,
        arguments: [SVDatabaseValue] = []
    ) throws -> Record? {

        try Record.fetchOne(
            db,
            sql: sql,
            arguments: StatementArguments(
                arguments.map(\.databaseValue)
            )
        )
    }
    
    func fetch<Record: FetchableRecord>(
        _ record: Record.Type,
        sql: String,
        arguments: [SVDatabaseValue] = []
    ) throws -> [Record] {
        
        try Record.fetchAll(
            db,
            sql: sql,
            arguments: StatementArguments(
                arguments.map(\.databaseValue)
            )
        )
    }
}

