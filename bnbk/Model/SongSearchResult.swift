//
//  SongSearchResult.swift
//  bnbk
//
//  Created by Heryan Djaruma on 26/08/24.
//

import Foundation

struct SongSearchResult: Codable, Identifiable {
    let id: String
    let songId: Int
    let title: Title
    let authors: [Author]?
    let type: String?
    let verse: [String]
    let chorus: [String]?
    let music: Music
    let category: Category
    let highlights: [HighlightSegment]
}

struct HighlightSegment: Codable, Identifiable {
    let value: String
    let type: String
    
    var id: UUID { UUID() }
}

struct SongSearchArrayResult: Codable {
    let data: [SongSearchResult]
}
