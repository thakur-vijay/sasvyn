//
//  SVSpotlightDestination.swift
//  SVSpotlightKit
//
//  Created by Vijay Thakur on 05/09/26.
//

import Foundation

public enum SVSpotlightDestination: Sendable, Equatable {
    case skill(id: String)
    case project(id: String)
    case experience(id: String)
    case education(id: String)
    case language(id: String)
    case socialLink(id: String)
    case document(id: String)

    public var identifier: String {
        switch self {
        case .skill(let id):
            "skill:\(id)"

        case .project(let id):
            "project:\(id)"

        case .experience(let id):
            "experience:\(id)"

        case .education(let id):
            "education:\(id)"

        case .language(let id):
            "language:\(id)"

        case .socialLink(let id):
            "socialLink:\(id)"

        case .document(let id):
            "document:\(id)"
        }
    }
}

public extension SVSpotlightDestination {

    init?(identifier: String) {
        let components = identifier.split(
            separator: ":",
            maxSplits: 1
        )

        guard components.count == 2 else {
            return nil
        }

        let type = String(components[0])
        let id = String(components[1])

        switch type {
        case "skill":
            self = .skill(id: id)

        case "project":
            self = .project(id: id)

        case "experience":
            self = .experience(id: id)

        case "education":
            self = .education(id: id)

        case "language":
            self = .language(id: id)

        case "socialLink":
            self = .socialLink(id: id)

        case "document":
            self = .document(id: id)

        default:
            return nil
        }
    }
}
