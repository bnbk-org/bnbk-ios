//
//  Song.swift
//  bnbk
//
//  Created by Heryan Djaruma on 18/05/24.
//

import Foundation

struct SongIndex: Codable, Identifiable {
    let id: String
    let songId: Int
    let title: TitleIndex
    let songType: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case songId
        case title
        case songType = "type"
    }
}

struct TitleIndex: Codable {
    let id: String
    let en: String?
    let nl: String?
    let kr: String?
}
