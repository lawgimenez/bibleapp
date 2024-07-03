//
//  AuthObservable.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/15/24.
//

import Foundation
import Supabase
import OSLog

private let logger = Logger(subsystem: "com.infinalab", category: "Auth")
private let client = SupabaseClient(supabaseURL: URL(string: Urls.supabaseBaseApi)!, supabaseKey: Urls.supabaseApiKey)

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

    init() {
        if UserDefaults.standard.string(forKey: User.Key.accessToken.rawValue) != nil {
            signInStatus = .success
        }
    }

    func signIn() async throws {
        let session = try await client.auth.signIn(email: email, password: password)
        UserDefaults.standard.set(session.user.email, forKey: User.Key.email.rawValue)
        UserDefaults.standard.set(session.accessToken, forKey: User.Key.accessToken.rawValue)
        UserDefaults.standard.set(session.refreshToken, forKey: User.Key.refreshToken.rawValue)
        UserDefaults.standard.set(session.user.id.uuidString, forKey: User.Key.uuid.rawValue)
        signInStatus = .success
        isSigningIn = false
    }

    func signUp() async throws {
        let session = try await client.auth.signUp(email: email, password: password)
        if let session = session.session {
            UserDefaults.standard.set(session.user.email, forKey: User.Key.email.rawValue)
            UserDefaults.standard.set(session.accessToken, forKey: User.Key.accessToken.rawValue)
            UserDefaults.standard.set(session.refreshToken, forKey: User.Key.refreshToken.rawValue)
            UserDefaults.standard.set(session.user.id.uuidString, forKey: User.Key.uuid.rawValue)
            let user = try await client.auth.session.user
            let userEncodable = UserEncodable(email: email, uuid: user.id.uuidString)
            let userResponse = try await client.from("User").insert(userEncodable).select().single().execute()
            if userResponse.status == 201 {
                signUpStatus = .success
            } else {
                signUpStatus = .failed
            }
        } else {
            signUpStatus = .failed
        }
    }
}
