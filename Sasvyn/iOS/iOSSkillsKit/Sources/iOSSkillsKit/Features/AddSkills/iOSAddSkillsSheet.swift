//
//  File.swift
//  iOSSkillsKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVDesignSystem

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
                ToolbarItem(placement: .topBarLeading) {
                    Button("", systemImage: "xmark") {
                        store.send(.closeTapped)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "checkmark") {
                        store.send(.addAllSkillsTapped)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func SearchAndAddSkillView()-> some View {
        Section {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    TextField("", text: $store.skillName, prompt: Text("Enter skill name"))
                    Button("Add") {
                        store.send(.addSkillTapped)
                    }
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
            Picker("Category", selection: $store.skillCategory) {
                ForEach(SkillCategory.allCases) { category in
                    Text(category.title)
                        .tag(category)
                }
            }
        } header: {
            Text("Select Category")
        } footer: {
            Button("Add"){
                store.send(.addSkillsTapped)
            }
        }
    }
    
    @ViewBuilder
    func SkillsView()-> some View {
        Section("Skills"){
            if store.skills.isEmpty{
                ContentUnavailableView("No skills added yet", systemImage: "wrench.and.screwdriver.fill")

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
                        Button("", systemImage: "pencil") {
                            
                        }
                        
                        Button("", systemImage: "trash") {
                            store.send(.deleteSkillTapped(skill))
                        }
                    }
                }
            }
        }
    }
}

