//
//  File.swift
//  iOSLibraryKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import Foundation

internal struct LibrarySectionModel: Identifiable{
    let id: Int
    let title: String
    let rows: [LibraryDestination]
    
    @MainActor static let sections: [Self] = [
        .init(
            id: 1,
            title: "Professional",
            rows: [
                .experience,
                .education,
                .skills,
                .documents
            ]
        ),
        .init(
            id: 2,
            title: "Profile",
            rows: [
                .about,
                .languages,
                .socialLinks,
                
            ]
        )
    ]
}
