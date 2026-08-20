//
//  SVColumnBuilder.swift
//  SVDatabaseKit
//
//  Created by Vijay Thakur on 26/06/26.
//


import GRDB

public final class SVColumnBuilder {

    private let column: ColumnDefinition

    init(column: ColumnDefinition) {
        self.column = column
    }

    @discardableResult
    public func primaryKey() -> Self {
        column.primaryKey()
        return self
    }

    @discardableResult
    public func notNull() -> Self {
        column.notNull()
        return self
    }

    @discardableResult
    public func unique() -> Self {
        column.unique()
        return self
    }

    @discardableResult
    public func defaults(to value: Bool) -> Self {
        column.defaults(to: value)
        return self
    }

    @discardableResult
    public func defaults(to value: Int) -> Self {
        column.defaults(to: value)
        return self
    }

    @discardableResult
    public func defaults(to value: String) -> Self {
        column.defaults(to: value)
        return self
    }
}
