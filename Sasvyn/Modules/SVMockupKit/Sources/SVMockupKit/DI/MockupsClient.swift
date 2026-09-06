//
//  SkillsClient.swift
//  SVSkillsKit
//
//  Created by Vijay Thakur on 17/08/26.
//

import ComposableArchitecture
import Foundation

public struct MockupsClient: Sendable{
    public var fetch:
        @Sendable () async throws -> [MockupImage]

    public var delete:
    @Sendable (_ id: String) async throws -> Void
    
    public var prepare:
    @Sendable(_ data: Data, _ mockup: Mockup) throws -> MockupModel?

    public var add:
    @Sendable (_ mockup: MockupModel) async throws -> Void
}

extension MockupsClient {

    static func live(
        fetchMockupsUseCase: FetchMockupsUseCase,
        addMockupUseCase: AddMockupUseCase,
        deleteMockupUseCase: DeleteMockupUseCase,
    ) -> Self {

        Self {
            try await fetchMockupsUseCase.execute()
        } delete: { id in
            try await deleteMockupUseCase.execute(id: id)
        } prepare: { data, mockup in
            try prepareMockup(data, mockup: mockup)
        } add: { mockup in
            try await addMockupUseCase.execute(mockup: mockup)
        }

    }
}

fileprivate extension MockupsClient {
    static func prepareMockup(_ data: Data, mockup: Mockup) throws -> MockupModel? {
        let id = mockup.id
        let device = mockup.device

        let mockupURL = try MockupStorage.mockupURL(for: id)
        try data.write(to: mockupURL)

        // Generate thumbnail
        guard let thumbnailData = Exporter.downsample(
            imageData: data,
            maxPixelSize: 512
        ) else {
            return nil
        }

        let thumbnailURL = try MockupStorage.thumbnailURL(for: id)
        try thumbnailData.write(to: thumbnailURL)

        let values = try mockupURL.resourceValues(
            forKeys: [
                .fileSizeKey,
                .contentModificationDateKey
            ]
        )
        let aspectRatio = (device.uiImage?.size.width ?? 0) / (device.uiImage?.size.height ?? 0)
        let mockupModel = MockupModel(
            id: id,
            url: mockupURL,
            thumbnail: thumbnailURL,
            size: Int64(values.fileSize ?? 0),
            device: device.assetName,
            aspectRatio: aspectRatio,
            createdAt: .now,
            updatedAt: .now
        )
        return mockupModel
    }
}

extension MockupsClient: DependencyKey {

    public static let liveValue = Self {
        fatalError("Unimplemented")
    } delete: { id in
        fatalError("Unimplemented")
    } prepare: { data, device in
        fatalError("Unimplemented")
    } add: { mockup in
        fatalError("Unimplemented")
    }

    
}

extension MockupsClient: TestDependencyKey {

    public static let testValue = Self {
        return []
    } delete: { id in
        
    } prepare: { data, device in
        return nil
    } add: { skills in
        
    }
}

public extension DependencyValues {

    var mockupsClient: MockupsClient {
        get { self[MockupsClient.self] }
        set { self[MockupsClient.self] = newValue }
    }
}
