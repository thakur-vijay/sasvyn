//
//  File.swift
//  SVNetwork
//
//  Created by Vijay Thakur on 23/09/26.
//

@preconcurrency import NetworkKit
import Foundation

public struct UploadEndpoint: Endpoint {
    public typealias Response = DataResponseDTO<UploadDTO>
    
    public let path: String = "/upload-url"
    
    public let method: HTTPMethod = .post
    
    public var body: RequestBody?
    public init(_ body: CreateUploadDTO) {
        self.body = .json(body)
    }
}
