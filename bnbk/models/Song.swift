//
//  Song.swift
//  bnbk
//
//  Created by Heryan Djaruma on 17/05/24.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

// MARK: - WelcomeElement
struct Song: Codable {
    var songID: Int
    var type: WelcomeType
    var title: Title
    var author: [Author]
    var chorus, verse: [String]
    var music: Music
    var category: Category

    enum CodingKeys: String, CodingKey {
        case songID
        case type, title, author, chorus, verse, music, category
    }
}

// MARK: - Author
struct Author: Codable {
    var name: String
}

// MARK: - Category
struct Category: Codable {
    var header: Header
    var type: CategoryType
}

enum Header: String, Codable {
    case keprajuritan = "Keprajuritan"
}

enum CategoryType: String, Codable {
    case peperanganRohani = "Peperangan Rohani"
}

// MARK: - Music
struct Music: Codable {
    var keyID, keyOg, tempo: String
    var bpm: Int
    var measure: Measure
    var btb, sasb, sf, ks: Int

    enum CodingKeys: String, CodingKey {
        case keyID
        case keyOg
        case tempo, bpm, measure, btb, sasb, sf, ks
    }
}

enum Measure: String, Codable {
    case the44 = "4/4"
    case the64 = "6/4"
    case the68 = "6/8"
    case the98 = "9/8"
}

// MARK: - Title
struct Title: Codable {
    var en, id: String
}

enum WelcomeType: String, Codable {
    case nyanyian = "nyanyian"
}
