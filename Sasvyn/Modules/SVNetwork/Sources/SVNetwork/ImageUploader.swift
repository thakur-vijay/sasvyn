//
//  ImageUploader.swift
//  SVNetwork
//
//  Created by Vijay Thakur on 23/09/26.
//


import Foundation
import NetworkKit

public protocol ImageUploader: Sendable {
    func upload(
        _ body: CreateUploadDTO,
        fileURL: URL
    ) async throws -> String
}

public final class DefaultImageUploader: ImageUploader, Sendable {

    private let client: NetworkClientProtocol
    private let httpClient: HTTPDataTask

    public init(
        client: NetworkClientProtocol,
        httpClient: HTTPDataTask
    ) {
        self.client = client
        self.httpClient = httpClient
    }

    public func upload(
        _ body: CreateUploadDTO,
        fileURL: URL
    ) async throws -> String {

        // 1. Get presigned upload URL
        let endpoint = UploadEndpoint(body)
        let response = try await client.request(endpoint)

        let uploadURL = response.data.uploadUrl
        let imageKey = response.data.imgKey

        // 2. Upload actual file
        let fileData = try Data(contentsOf: fileURL)

        guard let url = URL(string: uploadURL) else {
            throw ImageUploaderError.invalidUploadURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue(
            body.contentType,
            forHTTPHeaderField: "Content-Type"
        )
        request.httpBody = fileData

        let (_, urlResponse) = try await httpClient.data(
            for: request
        )

        guard let httpResponse = urlResponse as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw ImageUploaderError.uploadFailed
        }

        return imageKey
    }
}

public enum ImageUploaderError: Error {
    case invalidUploadURL
    case uploadFailed
}