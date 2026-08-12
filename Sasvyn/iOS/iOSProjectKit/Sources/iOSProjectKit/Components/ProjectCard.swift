//
//  File.swift
//  iOSProjectKit
//
//  Created by Vijay Thakur on 10/08/26.
//

import SwiftUI
import SVRemoteImage

public struct ProjectCard: View {
    private let onTap: ()->()
    public init(onTap: @escaping ()->()){
        self.onTap = onTap
    }
    
    @Environment(\.colorScheme) private var colorScheme
    public var body: some View {
        HStack(spacing: 12){
            SVRemoteImage(
                url: .init(string: "https://is1-ssl.mzstatic.com/image/thumb/Video221/v4/af/d5/53/afd553a2-196d-f6ef-ddac-dfc12cbcb788/1e89e771bf7935ff7ecef7c34d1440e0_Preview_Image_Intermediate_nonvideo_sdr_448319311_2726657810.png/632x632bb.webp"),
                size: .init(width: 90, height: 90),
                shape: .rect(cornerRadius: 5)
            )
            
            VStack(alignment: .leading, spacing: 3) {
                Text("6 AUGUST 2026")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(.systemGray))
                Text("MyTuur City Tour Guide")
                Text("MyTuur is a location-based city tour guide app that helps users discover places and plan optimized routes around a city. It uses Mapbox for maps/navigation and supports offline data, caching, and multilingual experiences.")
                    .font(.caption)
                    .foregroundStyle(Color(.systemGray2))
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Menu {
                Button("Edit", systemImage: "pencil"){
                    
                }
                
                Button("View", systemImage: "eye", action: onTap)
                
                Button("Delete", systemImage: "trash", role: .destructive){
                    
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.subheadline)
                    .foregroundStyle(Color(.systemGray))
                    .frame(width: 30, height: 30, alignment: .trailing)
                    .contentShape(.rect)
            }

        }
        .padding(.vertical, 10)
        .overlay(alignment: .bottom) {
            Divider()
                .padding(.leading, 102)
        }
        .contentShape(.rect)
        .onTapGesture(perform: onTap)
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
            .font(.footnote)
            .fontWeight(.medium)
            .foregroundStyle(tint)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(tint.tertiary, in: .capsule)
    }
}
