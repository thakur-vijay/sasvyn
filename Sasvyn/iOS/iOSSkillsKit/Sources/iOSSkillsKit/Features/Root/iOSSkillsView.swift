//
//  File.swift
//  iOSSkillsKit
//
//  Created by Vijay Thakur on 11/08/26.
//

import SwiftUI
import ComposableArchitecture
import SVDesignSystem

public struct iOSSKillsView: View {
    @Bindable var store: StoreOf<iOSSkillsFeature>
    
    public init(store: StoreOf<iOSSkillsFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(["Languages", "Frameworks", "Tools"], id: \.self) { sectionTitle in
                    SVSection(title: sectionTitle){
                        ChipLayoutUI(alignment: .leading, spacing: 10) {
                            ForEach(["SwiftUI", "UIkit", "Dart", "Flutter"], id: \.self) { skill in
                                SkillChip(skill: skill)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Skills")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "plus") {
                    store.send(.addSkillsTapped)
                }
            }
        }
        .sheet(item: $store.scope(state: \.destination, action: \.destination)) { store in
            switch store.case {
            case .addSkills(let store):
                iOSAddSkillsSheet(store: store)
            }
        }
    }
}
