//
//  AuthObservable.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/15/24.
//

import Foundation

@MainActor
class AuthObservable: ObservableObject {
    
    enum Status {
        case splash
        case success
        case loggedOut
        case failed
    }
    
    @Published var signUpStatus: Status = .loggedOut
    @Published var isSigningIn = false
    @Published var isSigningUp = false
    @Published var email = ""
    @Published var password = ""
}
