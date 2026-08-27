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
        let screenshotURL = ProjectStorage.screenshotURL(
            projectsDirectory: projectsDirectory,
            projectID: record.projectId,
            fileName: record.fileName
        )
        return ProjectScreenshot(
            id: record.id,
            mockupID: record.mockupID,
            device: record.device,
            imageURL: screenshotURL,
            aspectRatio: record.aspectRatio,
            order: record.sortOrder
        )
    }
}
