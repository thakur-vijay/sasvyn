//
//  AppSymbol.swift
//  SVDesignSystem
//
//  Created by Vijay Thakur on 31/07/26.
//

import Foundation

public enum SVSymbols {

    // MARK: - Common

    public static let close = SVSymbol("xmark")
    public static let home = SVSymbol("house")
    public static let trash = SVSymbol("trash")
    public static let edit = SVSymbol("applepencil.gen1")
    public static let about = SVSymbol("person.text.rectangle")
    public static let experience = SVSymbol("briefcase.fill")
    public static let education = SVSymbol("graduationcap.fill")
    public static let skills = SVSymbol("wrench.and.screwdriver.fill")
    public static let language = SVSymbol("character.bubble.fill")
    public static let appearance = SVSymbol("circle.lefthalf.filled")
    public static let privacy = SVSymbol("lock.shield.fill")
    public static let terms = SVSymbol("doc.plaintext.fill")
    public static let support = SVSymbol("questionmark.circle.fill")
    public static let logout = SVSymbol("iphone.and.arrow.forward.outward")

    // MARK: - Add

    public enum Add {
        public static let plain = SVSymbol("plus")
    }

    // MARK: - Check

    public enum Check {
        public static let plain = SVSymbol("checkmark")
        public static let circle = SVSymbol("checkmark.circle.fill")
    }

    // MARK: - Photo

    public enum Photo {
        public static let add = SVSymbol("photo.badge.plus")
        public static let empty = SVSymbol("photo.on.rectangle.angled")
    }

    // MARK: - Project

    public enum Project {
        public static let projects = SVSymbol("folder")
        public static let empty = SVSymbol("square.stack.3d.up")

        public enum Add {
            public static let fill = SVSymbol("folder.badge.plus.fill")
            public static let plain = SVSymbol("folder.badge.plus")
        }
    }

    // MARK: - Document

    public enum Document {
        public static let add = SVSymbol("document.badge.plus.fill")
        public static let document = SVSymbol("doc.text.fill")
        public static let empty = SVSymbol("doc.text.magnifyingglass")
    }

    // MARK: - Mockup

    public enum Mockup {
        public static let iphone = SVSymbol("iphone")
        public static let create = SVSymbol("rectangle.on.rectangle")
        public static let layout = SVSymbol("rectangle.expand.vertical")
        public static let export = SVSymbol("square.and.arrow.up")
        public static let applyToAll = SVSymbol("square.on.square")
    }

    // MARK: - Link

    public enum Link {
        public static let link = SVSymbol("link")
        public static let add = SVSymbol("link.badge.plus")
    }
}
