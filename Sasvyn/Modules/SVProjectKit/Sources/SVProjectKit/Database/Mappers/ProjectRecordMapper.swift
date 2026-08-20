//
//  ChatListRecordMapper.swift
//  Vynk
//
//  Created by Vijay Thakur on 21/06/26.
//

import Foundation

enum ProjectRecordMapper {

    nonisolated static func map(
        _ record: ProjectRecord,
        projectsDirectory: URL
    ) -> Project? {
        let appIcon = projectsDirectory.appending(path: record.iconPath)
        return Project(
            id: record.id,
            icon: appIcon,
            name: record.name,
            category: .init(rawValue: record.category),
            tagline: record.tagline,
            overview: record.overview
        )
    }
}

