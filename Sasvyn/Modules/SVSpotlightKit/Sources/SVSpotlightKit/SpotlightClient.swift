//
//  SpotlightClient.swift
//  SVSpotlightKit
//
//  Created by Vijay Thakur on 05/09/26.
//


import ComposableArchitecture
@preconcurrency import CoreSpotlight
import Foundation

public struct SpotlightClient: Sendable {
    public var index: @Sendable (
        _ item: SVSpotlightItem
    ) async throws -> Void
    
    public var indexMany: @Sendable (
        _ items: [SVSpotlightItem]
    ) async throws -> Void
    
    public var delete: @Sendable (
        _ identifier: String
    ) async throws -> Void
    
    public var deleteAll: @Sendable () async throws -> Void
}

extension SpotlightClient {
    public static let liveValue: Self = {
        let cSSearchableIndex = CSSearchableIndex(name: "com.sasvyn.spotlight")
        
        return Self(
            index: { item in
                let attributes = CSSearchableItemAttributeSet(
                    contentType: .data
                )
                
                attributes.title = item.title
                attributes.contentDescription = item.description
                attributes.keywords = item.keywords
                
                let searchableItem = CSSearchableItem(
                    uniqueIdentifier: item.destination.identifier,
                    domainIdentifier: item.domainIdentifier,
                    attributeSet: attributes
                )
                
                try await cSSearchableIndex.indexSearchableItems([
                    searchableItem
                ])
            },
            indexMany: { items in
                
                let searchableItems = items.map { item in
                    
                    let attributes = CSSearchableItemAttributeSet(
                        
                        contentType: .data
                        
                    )
                    
                    attributes.title = item.title
                    
                    attributes.contentDescription = item.description
                    
                    attributes.keywords = item.keywords
                    
                    return CSSearchableItem(
                        
                        uniqueIdentifier: item.destination.identifier,
                        
                        domainIdentifier: item.domainIdentifier,
                        
                        attributeSet: attributes
                        
                    )
                    
                }
                
                try await cSSearchableIndex.indexSearchableItems(
                    
                    searchableItems
                    
                )
                
            },
            delete: { identifier in
                try await cSSearchableIndex.deleteSearchableItems(
                    withIdentifiers: [identifier]
                )
            },
            
            deleteAll: {
                try await cSSearchableIndex.deleteAllSearchableItems()
            }
        )
    }()
}

extension SpotlightClient: TestDependencyKey {
    
    public static let testValue = Self { item in
        
    } indexMany: { items in
        
    } delete: { identifier in
        
    } deleteAll: {
        
    }
    
}

public extension DependencyValues {
    
    var spotlightClient: SpotlightClient {
        get { self[SpotlightClient.self] }
        set { self[SpotlightClient.self] = newValue }
    }
}
