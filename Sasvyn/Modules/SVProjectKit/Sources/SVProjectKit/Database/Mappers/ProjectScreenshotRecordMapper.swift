//
//  File.swift
//  SVProjectKit
//
//  Created by Vijay Thakur on 21/08/26.
//

import Foundation

enum ProjectScreenshotRecordMapper {

    nonisolated static func map(
        _ record: ProjectScreenshotRecord,
        projectsDirectory: URL
    ) -> ProjectScreenshot? {
        let screenshotURL = projectsDirectory.appending(path: record.path)
        return ProjectScreenshot(
            id: record.id,
            url: screenshotURL,
            order: record.order
        )
    }
}
