//
//  File.swift
//  iOSSkillsKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVDesignSystem
import SVSkillsKit

public struct iOSAddSkillsSheet: View {
    @Bindable var store: StoreOf<iOSAddSkillsFeature>
    
    public init(store: StoreOf<iOSAddSkillsFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            List {
                SearchAndAddSkillView()
                CategoryPicker()
                SVButton(
                    "Add",
                    systemImage: SVSymbols.Add.plain.name,
                    width: .flexible,
                    shape: .capsule) {
                        store.send(.addSkillTapped)
                    }
                    .clearListStyle()
                SkillsView()
            }
            .toolbar {
                SVToolbarItem.check {
                    store.send(.closeTapped)
                }
            }
            .categoryPicker(
                isPresented: $store.isSkillCategoryPickerPresented,
                title: "Select Skill Category",
                categories: SkillCategory.allCases,
                selection: $store.skillCategory) {}
        }
    }
    
    @ViewBuilder
    func SearchAndAddSkillView()-> some View {
        Section {
            SVEditableText(
                description: $store.skillName,
                placeholder: "Enter skill name",
                isExpandable: false,
                collapsedLineLimit: 1,
                characterLimit: 50,
                isEditable: true) {
                    
                }
        } header: {
            Text("Add Skills")
        } footer: {
            Text("You can add upto 5 skills with same category at once.")
        }
    }
    
    @ViewBuilder
    func CategoryPicker() -> some View {
        Section{
            Button {
                store.isSkillCategoryPickerPresented.toggle()
            } label: {
                LabeledContent("Category") {
                    Text(store.skillCategory?.title ?? "")
                }
            }
            .tint(.primary)
        } header: {
            Text("Select Category")
        }
    }
    
    @ViewBuilder
    func SkillsView()-> some View {
        Section("Skills"){
            if store.skills.isEmpty{
                SVContentUnavailableView(
                    title: "No Skills Yet",
                    symbol: SVSymbols.skills,
                    description: "Add new skills to see here."
                )
            }else {
                ForEach(store.skills) { skill in
                    HStack(spacing: 16) {
                        Text(skill.skill)
                            .font(.body.weight(.medium))
                        Spacer()
                        Text(skill.category.title)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("", systemImage: SVSymbols.trash.name) {
                            store.send(.deleteSkillTapped(skill))
                        }
                    }
                }
            }
        }
    }
}

