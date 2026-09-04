//
//  File.swift
//  iOSEducationKit
//
//  Created by Vijay Thakur on 29/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVDesignSystem
import SVEducationKit

internal struct EducationFormView: View {
    @Bindable var store: StoreOf<EducationFormFeature>

    init(store: StoreOf<EducationFormFeature>) {
        self.store = store
    }

    var body: some View {
        NavigationStack {
            List {
                educationSection
                durationSection
                gradeSection
                descriptionSection
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                SVToolbarItem.close {
                    store.send(.closeTapped)
                }
                
                SVToolbarItem.check(store.isDetailsReady) {
                    store.send(.saveTapped)
                }
            }
        }
    }
    
    private var navigationTitle: String {
        store.mode == .create ? "Add Education" : "Edit Education"
    }

    private var educationSection: some View {
        Section {
            SVEditableText(
                description: $store.education.degree,
                placeholder: "Degree",
                isExpandable: false,
                collapsedLineLimit: 1,
                characterLimit: 100,
                isEditable: true,
                font: .callout,
                onEditingEnded: {}
            )

            SVEditableText(
                description: $store.education.fieldOfStudy,
                placeholder: "Field of Study",
                isExpandable: false,
                collapsedLineLimit: 1,
                characterLimit: 100,
                isEditable: true,
                font: .callout,
                onEditingEnded: {}
            )

            SVEditableText(
                description: $store.education.institution,
                placeholder: "Institution",
                isExpandable: false,
                collapsedLineLimit: 1,
                characterLimit: 100,
                isEditable: true,
                font: .callout,
                onEditingEnded: {}
            )
        } header: {
            Text("Education")
                .textCase(.uppercase)
        }
    }

    private var durationSection: some View {
        Section {
            DatePicker(
                "Start Date",
                selection: $store.education.startDate,
                displayedComponents: .date
            )

            DatePicker(
                "End Date",
                selection: $store.education.endDate,
                displayedComponents: .date
            )
        } header: {
            Text("Duration")
                .textCase(.uppercase)
        }
    }

    private var gradeSection: some View {
        Section {
            SVEditableText(
                description: $store.education.grade,
                placeholder: "Grade",
                isExpandable: false,
                collapsedLineLimit: 1,
                characterLimit: 10,
                isEditable: true,
                font: .callout,
                onEditingEnded: {}
            )

            Picker("Grade Type", selection: $store.education.gradeType) {
                ForEach(GradeType.allCases, id: \.self) { type in
                    Text(type.rawValue)
                        .tag(type)
                }
            }
            .pickerStyle(.menu)
        } header: {
            Text("Grade")
                .textCase(.uppercase)
        }
    }

    private var descriptionSection: some View {
        Section {
            SVEditableText(
                description: $store.education.description,
                placeholder: "Add notes about your education",
                isExpandable: true,
                collapsedLineLimit: 3,
                characterLimit: 500,
                isEditable: true,
                font: .callout,
                onEditingEnded: {}
            )
            .frame(maxWidth: .infinity, alignment: .leading)
        } header: {
            Text("Description")
                .textCase(.uppercase)
        }
    }
}

enum EducationFormMode: Hashable, Sendable{
    case create
    case edit
}
