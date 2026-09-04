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
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    TextField("", text: $store.skillName, prompt: Text("Enter skill name"))
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    Button("Add") {
                        store.send(.addSkillTapped)
                    }
                    .disabledWithOpacity(store.skillName.isEmptyString)
                }
                
                if !store.skillNames.isEmpty {
                    ScrollView(.horizontal) {
                        HStack(spacing: 12) {
                            ForEach(store.skillNames, id: \.self) { skill in
                                SkillChip(skill: skill, background: .black, isDeleteHidden: false){
                                    store.send(.deleteSkillNameTapped(skill))
                                }
                                .tag(skill)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.viewAligned)
                    .scrollPosition(id: $store.skillNameScrollPosition)
                }
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
        } footer: {
            Button("Add"){
                store.send(.addSkillsTapped)
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
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
                        Button("", systemImage: "trash") {
                            store.send(.deleteSkillTapped(skill))
                        }
                    }
                }
            }
        }
    }
}

