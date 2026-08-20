//
//  DatabaseMigration.swift
//  Sayvyn
//
//  Created by Vijay Thakur on 03/06/26.
//

import Foundation

public protocol DatabaseMigration: Sendable{

    nonisolated var identifier: String { get }

    nonisolated func migrate(_ db: SVDatabase) throws

}
