//
//  SVDatabaseFilter.swift
//  SVDatabaseKit
//
//  Created by Vijay Thakur on 27/06/26.
//

import Foundation

public enum SVDatabaseFilter: Sendable{
    case equals(SVColumnName, SVDatabaseValue)
    case `in`(SVColumnName, [SVDatabaseValue])
}

internal extension SVDatabaseFilter {

    var expression: SQLSpecificExpressible {
        switch self {
        case let .equals(column, value):
            return Column(column.rawValue) == value.databaseValue
        case let .in(column, values):
            return values
                .map(\.databaseValue)
                .contains(Column(column.rawValue))
        }
    }

}
