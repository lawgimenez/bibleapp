//
//  User.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/26/24.
//

struct User {
    
    enum Keys: String {
        case email = "email"
        case accessToken = "accessToken"
        case refreshToken = "refreshToken"
    }
    
    var email: String
    var accessToken: String
    var refreshToken: String
    
    
}
