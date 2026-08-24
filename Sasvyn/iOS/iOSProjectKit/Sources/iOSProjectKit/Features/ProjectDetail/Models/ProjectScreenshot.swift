//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 16/08/26.
//

import Foundation
import CoreTransferable

public struct ProjectScreenshot: Identifiable, Codable, Equatable, Transferable{    
    public let id: UUID
    public var imageURL: URL?
    public var order: Int

    public init(
        id: UUID = UUID(),
        imageURL: URL? = nil,
        order: Int
    ) {
        self.id = id
        self.imageURL = imageURL
        self.order = order
    }
    
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .data)
    }
}
