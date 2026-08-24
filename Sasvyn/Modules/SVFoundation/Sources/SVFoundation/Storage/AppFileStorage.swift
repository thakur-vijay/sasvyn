//
//  FileStorage.swift
//  SVFoundation
//
//  Created by Vijay Thakur on 24/08/26.
//


import Foundation

public enum AppFileStorage {

    // MARK: - Application Support

    public static func applicationSupportDirectory() throws -> URL {
        try FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
    }

    // MARK: - Directory

    public static func directory(
        named name: String
    ) throws -> URL {
        let directory = try applicationSupportDirectory()
            .appendingPathComponent(name, isDirectory: true)

        try FileManager.default.createDirectory(
            at: directory,
            withIntermediateDirectories: true
        )

        return directory
    }

    // MARK: - File

    public static func fileURL(
        named fileName: String,
        in directory: String
    ) throws -> URL {
        try self.directory(named: directory)
            .appendingPathComponent(fileName)
    }

    // MARK: - Relative Path

    public static func relativePath(
        for url: URL,
        in directory: URL
    ) throws -> String {
        let directoryPath = directory
            .standardizedFileURL
            .path

        let filePath = url
            .standardizedFileURL
            .path

        guard filePath.hasPrefix(directoryPath + "/") else {
            throw AppFileStorageError.fileOutsideDirectory
        }

        return String(
            filePath.dropFirst(directoryPath.count + 1)
        )
    }

    // MARK: - Remove

    public static func removeItem(
        named fileName: String,
        from directory: String
    ) throws {
        let fileURL = try fileURL(
            named: fileName,
            in: directory
        )

        guard FileManager.default.fileExists(
            atPath: fileURL.path
        ) else {
            return
        }

        try FileManager.default.removeItem(
            at: fileURL
        )
    }

    // MARK: - Replace

    public static func replaceItem(
        at source: URL,
        with destination: URL
    ) throws {
        if FileManager.default.fileExists(
            atPath: destination.path
        ) {
            try FileManager.default.removeItem(
                at: destination
            )
        }

        try FileManager.default.moveItem(
            at: source,
            to: destination
        )
    }
}

public enum AppFileStorageError: Error {
    case fileOutsideDirectory
}
