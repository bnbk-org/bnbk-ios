//
//  Song.swift
//  bnbk
//
//  Created by Heryan Djaruma on 18/05/24.
//

import Foundation

struct SongIndex: Codable, Identifiable {
    let id: String
    let songId : Int
    let title : Title
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case songId
        case title
    }
}

struct Title: Codable, Identifiable {
    let en: String?
    let id: String
}
