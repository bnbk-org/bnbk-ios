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
    let title : TitleIndex
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case songId
        case title
    }
}

struct TitleIndex: Codable {
    let en: String?
    let id: String
}
