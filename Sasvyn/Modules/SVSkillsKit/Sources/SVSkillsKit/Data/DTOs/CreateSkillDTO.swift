//
//  File.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 05/10/26.
//

import Foundation

internal struct CreateSkillDTO: Encodable {
    let id: String
    let skill: String
    let category: String
}
