//
//  File.swift
//  SVDatabaseKit
//
//  Created by Vijay Thakur on 27/06/26.
//

import Foundation

public extension AppDatabase {
    @MainActor func observeAll<Record: SVFetchableRecord & SVTableRecord & Sendable>(
        _ record: Record.Type,
        where predicate: SVSQLExpression,
        orderedBy ordering: SVOrdering,
        onChange: @escaping @Sendable ([Record]) -> Void,
        onError: @escaping @Sendable (Error) -> Void
    ) -> DatabaseCancellable {

        let observation = ValueObservation.tracking { db in
            try record
                .filter(predicate)
                .order(ordering)
                .fetchAll(db)
        }

        return observation.start(
            in: dbQueue,
            scheduling: .mainActor,
            onError: onError,
            onChange: onChange
        )
    }
}

public extension AppDatabase {

    func observeAll<Record: SVFetchableRecord & SVTableRecord & Sendable>(
        _ record: Record.Type,
        filters: [SVDatabaseFilter] = [],
        sorting: [SVDatabaseSort] = []
    ) -> AsyncThrowingStream<[Record], Error> {

        AsyncThrowingStream { continuation in
            let dbQueue = self.dbQueue
            Task { @MainActor in
                let observation = ValueObservation.tracking { db in
                    var request = record.all()

                    for filter in filters {
                        request = request.filter(filter.expression)
                    }

                    for sort in sorting {
                        request = request.order(sort.ordering)
                    }

                    return try request.fetchAll(db)
                }

                let cancellable = observation.start(
                    in: dbQueue,
                    scheduling: .mainActor,
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
