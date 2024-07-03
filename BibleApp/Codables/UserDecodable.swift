//
//  UserDecodable.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/28/24.
//

import Foundation

struct UserDecodable: Decodable {

    let id: Int
    let email: String
    let uuid: String
}
