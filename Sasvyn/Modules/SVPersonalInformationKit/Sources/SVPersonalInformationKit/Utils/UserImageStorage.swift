//
//  DocumentStorage.swift
//  SVDocumentKit
//
//  Created by Vijay Thakur on 18/08/26.
//


import Foundation
import SVFoundation

public enum UserImageStorage {

    private static let directoryName = "User-Images"

    // MARK: - Directory

    public static func userImagesDirectory() throws -> URL {
        try FileStorage.directory(
            named: directoryName
        )
    }

    // MARK: - File

    public static func userImageURL(
        for fileName: String
    ) throws -> URL {
        try FileStorage.fileURL(
            named: fileName,
            in: directoryName
        )
    }
    
    public static func relativePath(
        for url: URL
    ) throws -> String {
        try FileStorage.relativePath(
            for: url,
            in: userImagesDirectory()
        )
    }
    
    public static func removeItem(path: String) throws {
        let itemURL = try UserImageStorage.userImageURL(for: path)
        print(String(describing: self), "Deleting image url", itemURL)
        if FileManager.default.fileExists(
            atPath: itemURL.path
        ) {
            try FileManager.default.removeItem(
                at: itemURL
            )
        }
    }
}
