//
//  File.swift
//  SVDocumentKit
//
//  Created by Vijay Thakur on 07/10/26.
//

import Foundation

internal struct CreateDocumentDTO: Encodable {
    let id: String
    let name: String
    let category: String
    let fileSize: Int64
    let key: String
}
