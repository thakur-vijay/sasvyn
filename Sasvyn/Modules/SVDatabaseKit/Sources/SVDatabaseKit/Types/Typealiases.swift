//
//  SwiftUIView.swift
//  SVDatabaseKit
//
//  Created by Vijay Thakur on 27/06/26.
//

import GRDB

public typealias SVFetchableRecord = FetchableRecord
public typealias SVPersistableRecord = PersistableRecord
public typealias SVTableRecord = TableRecord
public typealias SVColumn = Column
public typealias SVSQLExpression = SQLSpecificExpressible & Sendable
public typealias SVDatabaseValueConvertible = DatabaseValueConvertible
public typealias SVOrdering = SQLOrderingTerm & Sendable
public typealias SVDatabaseCancellable = DatabaseCancellable
