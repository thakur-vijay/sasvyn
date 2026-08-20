//
//  SwiftUIView.swift
//  iOSAuthKit
//
//  Created by Vijay Thakur on 15/08/26.
//


import SwiftUI
import SafariServices
import ComposableArchitecture
import AuthenticationServices

enum AuthURLType: String, CaseIterable, Identifiable{
    case termsOfService = "Terms of Service"
    case privacyPolicy = "Privacy Policy"
    
    var id: String { rawValue }
    
    var url: String {
        switch self {
        case .termsOfService: "https://www.apple.com"
        case .privacyPolicy: "https://www.apple.com"
        }
    }
}

public struct iOSAuthView: View {
    let store: StoreOf<iOSAuthFeature>
    
    public init(store: StoreOf<iOSAuthFeature>) {
        self.store = store
    }
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    @State private var clickedURL: AuthURLType?
    public var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 15){
                Image(systemName: "s.circle.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(.white, .purple.gradient)
                Text("What's New in \nSasvyn")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 20)
            
            VStack(alignment: .leading, spacing: 25) {
                PointView(
                    title: "Build Your Portfolio",
                    image: "person.text.rectangle",
                    description: "Create your professional developer profile."
                )
                
                PointView(
                    title: "Showcase Your Work",
                    image: "briefcase.fill",
                    description: "Present your projects, skills, and experience."
                )
                
                PointView(
                    title: "Share Your Profile",
                    image: "link",
                    description: "Give recruiters and clients one place to know your work."
                )
            }
            .padding(.horizontal, 25)
            
            Spacer(minLength: 0)
            
            Section {
                SignInWithAppleButton { request in
                    
                } onCompletion: { result in
                    store.send(.delegate(.loginSucceeded))
                }
                .signInWithAppleButtonStyle(.white)
                .frame(height: 55)
                .clipShape(.capsule)
                
            } header: {
                VStack(spacing: 4) {
                    Text("Sign in with Apple")
                        .font(.headline)
                    
                    Text("Use your Apple ID to sign in directly to Sasvyn.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .textCase(nil)
            } footer: {
                RichTextView(
                    configuration: .init(
                        text: "By signing in, you agree to our Terms of Service and Privacy Policy.",
                        links: [
                            .init(text: "Terms of Service", link: "/termsOfService"),
                            .init(text: "Privacy Policy.", link: "/privacyPolicy"),
                        ],
                        linkColor: .purple,
                        font: .subheadline
                    )) { clickedURL in
                        switch clickedURL {
                        case "/termsOfService":
                            self.clickedURL = .termsOfService
                        case "/privacyPolicy":
                            self.clickedURL = .privacyPolicy
                        default: break
                        }
                    }
                    .multilineTextAlignment(.center)
            }
        }
        .padding(15)
        .sheet(item: $clickedURL) { url in
            if let url = URL(string: url.url){
                SafariView(url: url)
            }
        }
    }
    
    @ViewBuilder
    private func PointView(
        title: String,
        image: String,
        description: String
    )-> some View {
        HStack(spacing: 15) {
            Image(systemName: image)
                .font(.largeTitle)
                .foregroundStyle(.purple)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(description)
                    .foregroundStyle(.gray)
            }
        }
    }
}


public struct RichTextView: View {
    let configuration: RichTextConfiguration
    let action: (String)->()
    
    public init(configuration: RichTextConfiguration, action: @escaping (String) -> Void) {
        self.configuration = configuration
        self.action = action
    }
    
    
    public var body: some View {
        Text(attributedText)
            .font(configuration.font)
            .environment(\.openURL, OpenURLAction { url in
                action(url.absoluteString)
                return .handled
                
            })
    }
    
    private var attributedText: AttributedString {
        
        var attributedString = AttributedString(configuration.text)
        
        for link in configuration.links {
            
            guard
                let range = attributedString.range(of: link.text),
                let url = URL(string: link.link)
            else {
                continue
            }
            
            attributedString[range].link = url
            attributedString[range].font = configuration.linkFont
            attributedString[range].foregroundColor = configuration.linkColor
            attributedString[range].underlineStyle = .none
        }
        
        return attributedString
    }
}

public struct RichTextConfiguration {
    
    public let text: String
    
    public let links: [RichTextLink]
    
    public let linkColor: Color
    
    public let font: Font
    
    public let linkFont: Font
    
    public init(
        text: String,
        links: [RichTextLink],
        linkColor: Color,
        font: Font,
        linkFont: Font? = nil
    ) {
        self.text = text
        self.links = links
        self.linkColor = linkColor
        self.font = font
        self.linkFont = linkFont ?? font
    }
}

public struct RichTextLink: Sendable, Hashable {
    
    public let text: String
    
    public let link: String
    
    public init(
        text: String,
        link: String
    ) {
        self.text = text
        self.link = link
    }
}

public struct SafariView: UIViewControllerRepresentable {

    private let url: URL

    public init(url: URL) {
        self.url = url
    }

    public func makeUIViewController(
        context: Context
    ) -> SFSafariViewController {
        let controller = SFSafariViewController(url: url)
        return controller
    }

    public func updateUIViewController(
        _ viewController: SFSafariViewController,
        context: Context
    ) {
        // Nothing to update.
    }
}
