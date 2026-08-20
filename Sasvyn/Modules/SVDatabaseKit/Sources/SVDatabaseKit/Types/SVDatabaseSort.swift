//
//  SVDatabaseSort.swift
//  SVDatabaseKit
//
//  Created by Vijay Thakur on 27/06/26.
//

import Foundation


public enum SVDatabaseSort: Sendable {

    case ascending(SVColumnName)

    case descending(SVColumnName)

}
