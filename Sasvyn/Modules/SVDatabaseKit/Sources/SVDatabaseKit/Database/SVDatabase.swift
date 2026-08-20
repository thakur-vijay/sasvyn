// The Swift Programming Language
// https://docs.swift.org/swift-book

import GRDB

public struct SVDatabase {
    let db: Database

    init(db: Database) {
        self.db = db
    }
}

