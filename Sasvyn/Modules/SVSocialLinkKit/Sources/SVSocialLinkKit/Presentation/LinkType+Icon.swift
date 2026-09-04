//
//  File.swift
//  SVSocialLinkKit
//
//  Created by Vijay Thakur on 31/08/26.
//

import SwiftUI

public extension LinkType {
    @ViewBuilder
    var icon: some View {
        switch self {
        case .github:
            GithubIcon()
                .fill(Color.accentColor)

        case .linkedin:
            LinkedInIcon()
                .fill(Color.accentColor)

        case .x:
            XIcon()
                .fill(Color.accentColor)

        case .instagram:
            InstagramIcon()
                .fill(Color.accentColor)

        case .youtube:
            YoutubeIcon()
                .fill(Color.accentColor)

        case .dribbble:
            DribbleIcon()
                .fill(Color.accentColor)

        case .behance:
            BehanceIcon()
                .fill(Color.accentColor)

        case .medium:
            MediumIcon()
                .fill(Color.accentColor)

        case .website:
            WebsiteIcon()
                .fill(Color.accentColor)
        }
    }
}
