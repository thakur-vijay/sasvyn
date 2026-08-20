//
//  DocumentStorage.swift
//  SVDocumentKit
//
//  Created by Vijay Thakur on 18/08/26.
//


import Foundation
import SVFoundation

public enum DocumentStorage {

    private static let directoryName = "Documents"

    // MARK: - Directory

    public static func documentsDirectory() throws -> URL {
        try FileStorage.directory(
            named: directoryName
        )
    }

    // MARK: - File

    public static func documentURL(
        for fileName: String
    ) throws -> URL {
        try FileStorage.fileURL(
            named: fileName,
            in: directoryName
        )
    }

    // MARK: - Relative Path

    public static func relativePath(
        for url: URL
    ) throws -> String {
        try FileStorage.relativePath(
            for: url,
            in: documentsDirectory()
        )
    }
}
