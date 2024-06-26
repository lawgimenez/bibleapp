//
//  AuthObservable.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/15/24.
//

import Foundation
import Supabase

@MainActor
class AuthObservable: ObservableObject {
    
    enum Status {
        case splash
        case success
        case loggedOut
        case failed
    }
    
    @Published var signUpStatus: Status = .loggedOut
    @Published var signInStatus: Status = .loggedOut
    @Published var isSigningIn = false
    @Published var isSigningUp = false
    @Published var email = ""
    @Published var password = ""
    private let client = SupabaseClient(supabaseURL: URL(string: "https://cllzdzrasqbvrdxiiirl.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNsbHpkenJhc3FidnJkeGlpaXJsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTg2MTA5OTUsImV4cCI6MjAzNDE4Njk5NX0.3Fi2y_kqTDU0Q2U6hvifYyt14n1O02iYCf9sIqjJV_I")
    
    init() {
        if UserDefaults.standard.string(forKey: User.Keys.accessToken.rawValue) != nil {
            signInStatus = .success
        }
    }
    
    func signIn() async throws {
        let session = try await client.auth.signIn(email: email, password: password)
        print("Sign in session = \(session)")
        UserDefaults.standard.set(session.user.email, forKey: User.Keys.email.rawValue)
        UserDefaults.standard.set(session.accessToken, forKey: User.Keys.accessToken.rawValue)
        UserDefaults.standard.set(session.refreshToken, forKey: User.Keys.refreshToken.rawValue)
        signInStatus = .success
    }
    
    func signUp() async throws {
        let session = try await client.auth.signUp(email: email, password: password)
        if let session = session.session {
            UserDefaults.standard.set(session.user.email, forKey: User.Keys.email.rawValue)
            UserDefaults.standard.set(session.accessToken, forKey: User.Keys.accessToken.rawValue)
            UserDefaults.standard.set(session.refreshToken, forKey: User.Keys.refreshToken.rawValue)
            signUpStatus = .success
        } else {
            signUpStatus = .failed
        }
    }
}
