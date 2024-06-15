//
//  AuthObservable.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/15/24.
//

import Foundation

@MainActor
class AuthObservable: ObservableObject {
    
    @Published var isSigningIn = false
    @Published var email = ""
    @Published var password = ""
}
