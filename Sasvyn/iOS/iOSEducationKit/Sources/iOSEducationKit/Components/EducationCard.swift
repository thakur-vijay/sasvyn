//
//  File.swift
//  iOSEducationKit
//
//  Created by Vijay Thakur on 29/08/26.
//

import SwiftUI
import SVEducationKit
import SVDesignSystem

internal struct EducationCard: View {
    let education: Education
    
    init(_ education: Education) {
        self.education = education
    }
    var body: some View {
        HStack(spacing: 12) {
            SVSymbols.education.image
                .font(.system(size: 24))
                .fontWeight(.bold)
                .foregroundStyle(.blue)
                .frame(width: 30, height: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(education.degree)
                    .font(.title3)
                    .fontWeight(.bold)
                Text(education.fieldOfStudy)
                    .font(.callout)
                    .foregroundStyle(Color(.secondaryLabel))
                Text(education.institution)
                    .font(.callout)
                Text("\(formatted(education.startDate)) - \(education.isPursuing ? "Present" : formatted(education.endDate)) • \(education.grade) \(education.gradeType.rawValue)")
                    .font(.callout)
                    .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 16)
        .background(.background)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.separator)
                .frame(height: 1)
                .padding(.leading, 42)
        }
    }
    
    func formatted(_ date: Date)-> String {
        date.formatted(.dateTime.month(.abbreviated).year())
    }
}
