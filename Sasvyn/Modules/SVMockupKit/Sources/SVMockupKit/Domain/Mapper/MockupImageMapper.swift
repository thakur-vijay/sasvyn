//
//  MockupImageMapper.swift
//  SVMockupKit
//
//  Created by Vijay Thakur on 24/08/26.
//

import Foundation

public enum MockupImageMapper {

    public nonisolated static func map(
        _ model: MockupModel,
    ) -> MockupImage{
        return MockupImage(
            id: model.id,
            device: model.device,
            url: model.url,
            thumbnail: model.thumbnail,
            aspectRatio: model.aspectRatio
        )
    }
}
