//
//  File.swift
//  iOSMockupKit
//
//  Created by Vijay Thakur on 23/08/26.
//

import ComposableArchitecture
import SVMockupKit

@Reducer
public struct iOSDevicePickerFeature {
    
    @ObservableState
    public struct State: Equatable {
        var selectedGeneration: String? = Devices.generations.first {
            didSet {
                if selectedVariant == nil {
                    selectedVariant = Devices.variants(for: selectedGeneration ?? "").first
                }
            }
        }
        
        var selectedVariant: String?
        public init(selectedDevice: Device?){
            self.selectedVariant = selectedDevice?.variant
            self.selectedGeneration = selectedDevice?.generation
        }
    }
    
    public enum Action{
        case closeTapped
        case deviceSelected(Device)
        case generationTapped(String)
        case variantTapped(String)
        case delegate(Delegate)
        
        public enum Delegate {
            case close
            case deviceSelected(Device)
        }
    }
    
    public init(){
        
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .closeTapped:
                return .send(.delegate(.close))
            case .delegate(_):
                return .none
            case .deviceSelected(let device):
                return .send(.delegate(.deviceSelected(device)))
            case .generationTapped(let generation):
                state.selectedVariant = nil
                state.selectedGeneration = generation
                return .none
            case .variantTapped(let variant):
                state.selectedVariant = variant
                return .none
            }
        }
    }
}
