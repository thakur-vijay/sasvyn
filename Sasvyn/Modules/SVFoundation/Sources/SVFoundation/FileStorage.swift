//
//  FileStorage.swift
//  SVFoundation
//
//  Created by Vijay Thakur on 20/08/26.
//

import Foundation

public enum FileStorage {

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
            throw FileStorageError.fileOutsideDirectory
        }

        return String(
            filePath.dropFirst(directoryPath.count + 1)
        )
    }
    
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

public enum FileStorageError: Error {
    case fileOutsideDirectory
}
