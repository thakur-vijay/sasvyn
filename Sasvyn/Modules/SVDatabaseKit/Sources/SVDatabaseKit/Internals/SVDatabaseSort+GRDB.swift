//
//  File.swift
//  SVDatabaseKit
//
//  Created by Vijay Thakur on 27/06/26.
//

import GRDB

extension SVDatabaseSort {

    var ordering: SQLOrderingTerm {

        switch self {

        case .ascending(let column):
            return Column(column.rawValue).asc

        case .descending(let column):
            return Column(column.rawValue).desc

        }

    }

}
