//
//  SwiftUIView.swift
//  SVPortfolioKit
//
//  Created by Vijay Thakur on 31/07/26.
//

import SwiftUI

public struct PortfolioCard: View {
    
    public init(){
        
    }
    
    public var body: some View {
        GeometryReader {
            let size = $0.size
            AsyncImage(
                url: .init(
//                    string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQO1ixJGL5xfVzCm2rB4xu8d8yBUxlj9EmCsWfFvNzjnrLPR-rXS1SBz10&s=10"
                    string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwJV1F9JuYVXHuWLlOgaTiOfJJUO4CmD-DzQ1xBgvtTA&s=10"
                )
            )
            .aspectRatio(contentMode: .fit)
            .frame(width: size.width, height: size.height, alignment: .top)
        }
        .aspectRatio(16/9,contentMode: .fill)
        .overlay {
            LinearGradient(colors: [
                .black.opacity(0.75),
                .black.opacity(0.5),
                .black.opacity(0.2),
                .black.opacity(0.5),
                .black.opacity(0.75),
            ], startPoint: .top, endPoint: .bottom)
            .overlay {
                VStack {
                    HStack {
                        HStack {
                            Circle()
                                .fill(.green.secondary)
                                .frame(width: 7, height: 7)
                            Text("Live")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                        }
                        Spacer()
                        glassActionButton(text: "amanportfolio.dev", icon: "safari") {
                            
                        }
                        
                        glassActionButton(icon: "ellipsis") {
                            
                        }
                    }
                    Spacer()
                    InfoView()
                }
                .padding(12)
            }
        }
        .clipShape(.rect(cornerRadius: 12, style: .continuous))
    }
    
    @ViewBuilder
    func glassActionButton(text: String? = nil, icon: String, action: @escaping ()-> ())-> some View {
        Button(action: action) {
            HStack(spacing: 6){
                if let text {
                    Text(text)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                
                Image(systemName: icon)
                    .font(.subheadline)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, text == nil ? 0 : 10)
            .frame(width: text == nil ? 30 : nil, height: 30)
            .background(.ultraThinMaterial, in: .rect(cornerRadius: 6, style: .continuous))
            
        }
    }
    
    @ViewBuilder
    func InfoContainer(icon: String, label: String, value: String)-> some View {
        HStack(spacing: 5){
            glassActionButton(icon: icon) {}
            VStack(alignment: .leading, spacing: 3){
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
                Text(value)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
            }
        }
    }
    
    @ViewBuilder
    func InfoView()-> some View {
        HStack {
            InfoContainer(icon: "calendar", label: "Published", value: "2 days ago")
            Spacer()
            InfoContainer(icon: "person.2", label: "Visitors", value: "842")
        }
    }
}

public extension View {
    @ViewBuilder
    func glassBackground<S: Shape>(in shape: S)-> some View {
        if #available(iOS 26.0, *) {
            self
                .glassEffect(.clear, in: shape)
        } else {
            self
                .background(.ultraThinMaterial, in: shape)
        }
    }
}

public struct ChipView: View {
    let status: String
    let tint: Color
    
    public init(status: String, tint: Color) {
        self.status = status
        self.tint = tint
    }
    
    public var body: some View {
        Text(status)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundStyle(tint)
            .padding(6)
            .background(tint.tertiary, in: .capsule)
    }
}
