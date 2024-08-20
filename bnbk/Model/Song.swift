//
//  Song.swift
//  bnbk
//
//  Created by Heryan Djaruma on 18/05/24.
//

import Foundation

// base model for a song
struct Song: Codable, Identifiable {
    let id: String
    let songId: Int
    let title: Title
    let authors: [Author]?
    let type: String
    let verse: [String]
    let chorus: [String]?
    let music: Music
    let category: Category
}

struct Title: Codable {
    let en: String?
    let id: String
    let nl: String?
    let kr: String?
}

struct Author: Codable, Hashable {
    let name: String
    let uid: String?
}

struct Music: Codable {
    let keyId: String?
    let keyOg: String?
    let measure: String?
    let tempo: String?
    let bpm: Int?
    let btb: Int?
    let crossBtb: Int?
    let sasb: Int?
    let sf: Int?
    let ks: Int?
}

struct Category: Codable {
    let header: String
    let type: String
}
