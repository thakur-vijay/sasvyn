//
//  File.swift
//  AuthKit
//
//  Created by Vijay Thakur on 20/09/26.
//

import Foundation

internal protocol AuthRepository: Sendable{
    
    func appleLogin(_ body: LoginRequestDTO) async throws-> User
}
