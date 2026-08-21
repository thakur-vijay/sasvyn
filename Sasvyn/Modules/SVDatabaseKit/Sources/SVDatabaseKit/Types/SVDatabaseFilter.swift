//
//  SVDatabaseFilter.swift
//  SVDatabaseKit
//
//  Created by Vijay Thakur on 27/06/26.
//

import Foundation

public indirect enum SVDatabaseFilter: Sendable {
    case equals(SVColumnName, SVDatabaseValue)
    case `in`(SVColumnName, [SVDatabaseValue])
    case like(SVColumnName, String)
    case and(SVDatabaseFilter, SVDatabaseFilter)
    case or(SVDatabaseFilter, SVDatabaseFilter)
}

internal extension SVDatabaseFilter {

    var expression: SQLExpression {
        switch self {

        case let .equals(column, value):
            return Column(column.rawValue) == value.databaseValue

        case let .in(column, values):
            return values
                .map(\.databaseValue)
                .contains(Column(column.rawValue))

        case let .like(column, value):
            return Column(column.rawValue).like("%\(value)%")

        case let .and(lhs, rhs):
            return lhs.expression && rhs.expression

        case let .or(lhs, rhs):
            return lhs.expression || rhs.expression
        }
    }
}

public extension SVDatabaseFilter {

    static func or(_ filters: [SVDatabaseFilter]) -> SVDatabaseFilter {
        precondition(!filters.isEmpty)

        return filters.dropFirst().reduce(filters[0]) {
            .or($0, $1)
        }
    }
}
