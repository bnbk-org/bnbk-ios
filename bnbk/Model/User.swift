//
//  User.swift
//  bnbk
//
//  Created by Heryan Djaruma on 20/09/24.
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    var username: String?
    let email: String?
    var phone: String?
    var bio: String?
}
