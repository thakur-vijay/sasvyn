//
//  File.swift
//  SVHomeKit
//
//  Created by Vijay Thakur on 01/09/26.
//

import Foundation

internal protocol HomeRepository: Sendable {
    func fetchRecentProjects(limit: Int = 5)
}
