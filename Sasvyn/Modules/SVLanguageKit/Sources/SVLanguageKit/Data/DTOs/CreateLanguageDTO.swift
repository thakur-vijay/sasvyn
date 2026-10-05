//
//  File.swift
//  SVLanguageKit
//
//  Created by Vijay Thakur on 05/10/26.
//

import Foundation

internal struct CreateLanguageDTO: Encodable {
    let id: String
    let languageCode: String
    let language: String
    let proficiency: Int16
}
