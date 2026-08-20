//
//  ProjectStorage.swift
//  SVProjectKit
//
//  Created by Vijay Thakur on 20/08/26.
//

import Foundation
import SVFoundation

public enum ProjectStorage {

    private static let directoryName = "Projects"

    // MARK: - Projects

    public static func projectsDirectory() throws -> URL {
        try FileStorage.directory(
            named: directoryName
        )
    }
    
    public static func projectDirectoryURL(
        id: String
    ) throws -> URL {
        try projectsDirectory()
            .appendingPathComponent(id, isDirectory: true)
    }

    public static func projectDirectory(
        id: String
    ) throws -> URL {
        let directory = try projectsDirectory()
            .appendingPathComponent(id, isDirectory: true)

        try FileManager.default.createDirectory(
            at: directory,
            withIntermediateDirectories: true
        )

        return directory
    }

    // MARK: - App Icon

    public static func appIconURL(
        projectID: String
    ) throws -> URL {
        try projectDirectory(id: projectID)
            .appendingPathComponent(
                "app-icon",
                isDirectory: false
            )
            .appendingPathExtension("png")
    }

    // MARK: - Screenshots

    public static func screenshotsDirectory(
        projectID: String
    ) throws -> URL {
        let directory = try projectDirectory(id: projectID)
            .appendingPathComponent(
                "screenshots",
                isDirectory: true
            )

        try FileManager.default.createDirectory(
            at: directory,
            withIntermediateDirectories: true
        )

        return directory
    }

    public static func screenshotURL(
        projectID: String,
        fileName: String
    ) throws -> URL {
        try screenshotsDirectory(projectID: projectID)
            .appendingPathComponent(fileName)
    }
    
    public static func relativePath(
        for url: URL
    ) throws -> String {
        try FileStorage.relativePath(
            for: url,
            in: projectsDirectory()
        )
    }
}
