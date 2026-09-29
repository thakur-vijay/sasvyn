//
//  File.swift
//  SVSocialLinkKit
//
//  Created by Vijay Thakur on 29/09/26.
//

import Foundation
import SVNetwork

internal struct SocialLinkReponseDTO: Codable, Sendable, Hashable{
    let id: String
    let userId: String
    let type: String
    let url: String
    let createdAt: Date
    let updatedAt: Date
}
