//
//  File.swift
//  SVSocialLinkKit
//
//  Created by Vijay Thakur on 30/09/26.
//

import Foundation

enum SocialLinkDTOMapper {

    nonisolated static func map(
        _ dto: SocialLinkReponseDTO,
    ) -> SocialLink {
        return .init(
            id: dto.id,
            type: .init(rawValue: dto.type),
            url: .init(string: dto.url),
            syncVersion: dto.syncVersion,
            updatedAt: dto.updatedAt
        )
    }
}


