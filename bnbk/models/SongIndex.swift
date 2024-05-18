//
//  Song.swift
//  bnbk
//
//  Created by Heryan Djaruma on 18/05/24.
//

import Foundation

struct SongIndex: Codable, Identifiable {
    let id: Int
    let songId : Int
    let title : Title
}

struct Title: Codable, Identifiable {
    let en: String
    let id: String
}
