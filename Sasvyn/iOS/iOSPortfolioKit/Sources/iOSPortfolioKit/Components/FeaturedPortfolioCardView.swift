//
//  FeaturedPortfolioCardView.swift
//  iOSPortfolioKit
//
//  Created by Vijay Thakur on 12/08/26.
//

import SwiftUI
import SVRemoteImage

public struct FeaturedPortfolioCardView: View {
    
    public init(){
        
    }
    
    public var body: some View {
        GeometryReader { reader in
            let minY = reader.frame(in: .global).minY
            let size = reader.size
            let scale = minY > 0 ? 1 + (minY / size.height) : 1

            SVRemoteImage(
                url: .init(
                    string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRdaNWCdBRdEmgRVVVm2shDcgV0tcDRjEOjQLCoisOEaQ&s=10"
                ),
                size: .init(
                    width: size.width,
                    height: size.height
                ),
                shape: .rect
            )
            .overlay(alignment: .bottom) {
                LinearGradient(
                    colors: [
                        .clear,
                        .clear,
                        .clear,
                        .black.opacity(0.2),
                        .black.opacity(0.4),
                        .black.opacity(0.6),
                        .black.opacity(0.8),
                        .black.opacity(0.9),
                        .black
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .overlay(alignment: .bottom) {
                    VStack {
                        Spacer()
                        HStack(spacing: 6){
                            Circle()
                                .fill(.green.secondary)
                                .frame(width: 10, height: 10)
                            Text("Live")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.black, in: .capsule)
                        .overlay {
                            Capsule()
                                .stroke(.separator, lineWidth: 0.5)
                        }
                        
                        Text("Sasvyn Portfolio")
                            .font(.largeTitle.bold())
                            .lineLimit(1)
                            .italic()
                        Text("Published on 12 August 2026")
                            .font(.subheadline)
                            .foregroundStyle(Color(.systemGray2))
                        
                        HStack(spacing: 12){
                            Button {
                                // Open published portfolio
                            } label: {
                                Label("View Portfolio", systemImage: "globe")
                                    .foregroundStyle(.black)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.white)
                            
                            Menu {
                                Button("Details", systemImage: "info.circle") {
                                    // Open portfolio detail screen
                                }
                                

                                Button("Edit", systemImage: "pencil") {
                                    // Edit portfolio
                                }

                                Button("Delete", systemImage: "trash", role: .destructive) {
                                    // Delete portfolio
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .foregroundStyle(.white)
                            }
                            .menuStyle(.button)
                        }

                    }
                    .padding()
                }
            }
            .scaleEffect(
                scale,
                anchor: .top
            )
            .offset(
                y: minY > 0
                    ? -minY
                    : -minY * 0.1
            )
        }
        .containerRelativeFrame(.vertical) { value, _ in
            value * 0.5
        }
    }
}
