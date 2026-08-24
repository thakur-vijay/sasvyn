//
//  DocumentStorage.swift
//  SVDocumentKit
//
//  Created by Vijay Thakur on 18/08/26.
//


import Foundation
import SVFoundation

public enum MockupStorage {

    private static let directoryName = "Mockups"

    // MARK: - Directory

    public static func mockupsDirectory() throws -> URL {
        try FileStorage.directory(
            named: directoryName
        )
    }

    // MARK: - File

    public static func mockupURL(
        for fileName: String
    ) throws -> URL {
        try FileStorage.fileURL(
            named: fileName,
            in: directoryName
        )
    }
    
    public static func thumbnailURL(
        for fileName: String
    ) throws -> URL {
        try FileStorage.fileURL(
            named: "\(fileName)_thumbnail",
            in: directoryName
        )
    }

    // MARK: - Relative Path

    public static func relativePath(
        for url: URL
    ) throws -> String {
        try FileStorage.relativePath(
            for: url,
            in: mockupsDirectory()
        )
    }
    
    public static func removeItem(path: String) throws {
        let itemURL = try MockupStorage.mockupURL(for: path)
        print(String(describing: self), "Deleting mockup", itemURL)
        if FileManager.default.fileExists(
            atPath: itemURL.path
        ) {
            try FileManager.default.removeItem(
                at: itemURL
            )
        }
    }
}
