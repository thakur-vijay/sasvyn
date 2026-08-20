//
//  SVDatabaseValue.swift
//  SVDatabaseKit
//
//  Created by Vijay Thakur on 26/06/26.
//

import Foundation
import GRDB


public enum SVDatabaseValue: Sendable{
    case text(String)
    case integer(Int)
    case bool(Bool)
    case date(Date)
    case data(Data)
    case null
}

extension SVDatabaseValue {
    var databaseValue: DatabaseValue {
        switch self {
        case .text(let value):
            return value.databaseValue
        case .integer(let value):
            return value.databaseValue
        case .bool(let value):
            return value.databaseValue
        case .date(let value):
            return value.databaseValue
        case .data(let value):
            return value.databaseValue
        case .null:
            return DatabaseValue.null
        }
    }
}
