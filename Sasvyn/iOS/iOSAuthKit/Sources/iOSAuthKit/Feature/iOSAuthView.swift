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
import SVDesignSystem

public struct iOSAuthView: View {
    let store: StoreOf<iOSAuthFeature>
    
    public init(store: StoreOf<iOSAuthFeature>) {
        self.store = store
    }
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    @State private var clickedItem: WebItem?
    
    public var body: some View {
        NavigationStack{
            VStack(spacing: 15) {
                VStack(spacing: 15){
                    SVSymbols.appSymbol.image
                        .font(.system(size: 100))
                        .foregroundStyle(.white, Color.accentColor.gradient)
                    Text("What's New in \nSasvyn")
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 20)
                
                VStack(alignment: .leading, spacing: 25) {
                    PointView(
                        title: "Build Your Portfolio",
                        symbol: SVSymbols.about,
                        description: "Create your professional developer profile."
                    )
                    
                    PointView(
                        title: "Showcase Your Work",
                        symbol: SVSymbols.experience,
                        description: "Present your projects, skills, and experience."
                    )
                    
                    PointView(
                        title: "Share Your Profile",
                        symbol: SVSymbols.Link.link,
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
                    .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
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
                            linkColor: Color.accentColor,
                            font: .subheadline
                        )) { clickedURL in
                            switch clickedURL {
                            case "/termsOfService":
                                self.clickedItem = .init(url: .init(string: "https://www.apple.com")!)
                            case "/privacyPolicy":
                                self.clickedItem = .init(url: .init(string: "https://www.apple.com")!)
                            default: break
                            }
                        }
                        .multilineTextAlignment(.center)
                }
            }
            .padding(15)
            .web($clickedItem)
        }
    }
    
    @ViewBuilder
    private func PointView(
        title: String,
        symbol: SVSymbol,
        description: String
    )-> some View {
        HStack(spacing: 15) {
            symbol.image
                .font(.largeTitle)
                .foregroundStyle(Color.accentColor)
            
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
