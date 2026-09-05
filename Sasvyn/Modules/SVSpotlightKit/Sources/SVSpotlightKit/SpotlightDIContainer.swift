//
//  File.swift
//  SVSpotlightKit
//
//  Created by Vijay Thakur on 05/09/26.
//

import Foundation
import ComposableArchitecture

@available(iOS 18.0, *)
public final class SpotlightDIContainer{
    
    public init(){
        
    }
    public func register(_ values: inout DependencyValues) {
        values.spotlightClient = SpotlightClient.liveValue
    }
    
}
