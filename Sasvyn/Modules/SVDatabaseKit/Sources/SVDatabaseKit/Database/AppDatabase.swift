//
//  AppDatabase.swift
//  Sasvyn
//
//  Created by Vijay Thakur on 03/06/26.
//

import Foundation
@_exported import GRDB

public final class AppDatabase: @unchecked Sendable {

    public let dbQueue: DatabaseQueue

    public init(
        configuration: DatabaseConfiguration = .live,
        migrator: DatabaseMigrator
    ) throws {

        let databaseURL = try Self.databaseURL(
            filename: configuration.filename
        )

        var config = GRDB.Configuration()

        config.prepareDatabase { db in
            try db.execute(sql: "PRAGMA foreign_keys = ON")
        }

        dbQueue = try DatabaseQueue(
            path: databaseURL.path,
            configuration: config
        )

        try migrator
            .build()
            .migrate(dbQueue)
    }

    private static func databaseURL(
        filename: String
    ) throws -> URL {
        guard let documentsURL = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            throw DatabaseError.documentsDirectoryNotFound
        }

        return documentsURL.appendingPathComponent(filename)
    }
    
    public func read<T: Sendable>(
        _ block: @Sendable @escaping (SVDatabase) throws -> T
    ) async throws -> T {
        try await dbQueue.read { db in
            try block(SVDatabase(db: db))
        }
    }
    
    @discardableResult
    public func write<T: Sendable>(
        _ block: @Sendable @escaping (SVDatabase) throws -> T
    ) async throws -> T {
        try await dbQueue.write { db in
            try block(SVDatabase(db: db))
        }
    }
    
    public func observeAll<Record: SVFetchableRecord & SVTableRecord & Sendable>(
        _ record: Record.Type,
        where predicate: SVSQLExpression? = nil,
        orderedBy column: SVColumn? = nil
    ) -> AsyncThrowingStream<[Record], Error> {
        AsyncThrowingStream { continuation in
            let dbQueue = dbQueue
            Task { @MainActor in
                let observation = ValueObservation.tracking { db in
                    var request = record.all()

                    if let predicate {
                        request = request.filter(predicate)
                    }

                    if let column {
                        request = request.order(column)
                    }

                    return try request.fetchAll(db)
                }

                let cancellable = observation.start(
                    in: dbQueue,
                    onError: { error in
                        continuation.finish(throwing: error)
                    },
                    onChange: { records in
                        continuation.yield(records)
                    }
                )

                continuation.onTermination = { _ in
                    cancellable.cancel()
                }
            }
        }
    }
}
