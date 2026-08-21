//
//  File.swift
//  SVDatabaseKit
//
//  Created by Vijay Thakur on 20/08/26.
//

import GRDB

public final class SVTableAlterationBuilder {

    private let table: TableAlteration

    init(table: TableAlteration) {
        self.table = table
    }

    @discardableResult
    public func text(_ name: String) -> SVColumnAlterationBuilder {
        SVColumnAlterationBuilder(
            column: table.add(column: name, .text)
        )
    }

    @discardableResult
    public func integer(_ name: String) -> SVColumnAlterationBuilder {
        SVColumnAlterationBuilder(
            column: table.add(column: name, .integer)
        )
    }

    @discardableResult
    public func boolean(_ name: String) -> SVColumnAlterationBuilder {
        SVColumnAlterationBuilder(
            column: table.add(column: name, .boolean)
        )
    }

    @discardableResult
    public func datetime(_ name: String) -> SVColumnAlterationBuilder {
        SVColumnAlterationBuilder(
            column: table.add(column: name, .datetime)
        )
    }

    @discardableResult
    public func blob(_ name: String) -> SVColumnAlterationBuilder {
        SVColumnAlterationBuilder(
            column: table.add(column: name, .blob)
        )
    }
}
