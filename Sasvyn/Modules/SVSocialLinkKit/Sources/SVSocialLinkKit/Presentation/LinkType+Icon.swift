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

        case .linkedin:
            LinkedInIcon()

        case .x:
            XIcon()

        case .instagram:
            InstagramIcon()

        case .youtube:
            YoutubeIcon()

        case .dribbble:
            DribbleIcon()

        case .behance:
            BehanceIcon()

        case .medium:
            MediumIcon()

        case .website:
            WebsiteIcon()
        }
    }
}
