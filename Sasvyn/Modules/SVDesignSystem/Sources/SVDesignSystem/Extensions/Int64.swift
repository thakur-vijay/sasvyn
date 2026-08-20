//
//  File.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 18/08/26.
//

import Foundation

public extension Int64 {
    func formattedFileSize() -> String {

        let formatter = ByteCountFormatter()
        formatter.countStyle = .file

        return formatter.string(
            fromByteCount: self
        )
    }
}
