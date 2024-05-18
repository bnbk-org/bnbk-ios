//
//  Response.swift
//  bnbk
//
//  Created by Heryan Djaruma on 18/05/24.
//

import Foundation

struct Response: Codable {
    let code: Int
    let status: String
    let data: Song?
    let paging: String?
    let errors: String?
    let metadata: String?
}
