//
//  ChapterData.swift
//  EZBook
//
//  Created by Paing Zay on 2/12/23.
//

import Foundation

struct ChapterData: Codable {
    let data: [Chapter]
}

struct SingleChapterData: Codable {
    let data: Chapter
}

struct Chapter: Codable {
    let id: String
    let type: String
    let attributes: ChapterAttributes
}

struct ChapterAttributes: Codable {
//    let createdAt: String
//    let updatedAt: String
//    let synopsis: String
//    let description: String
//    let titles: [String: String]
//    let canonicalTitle: String?
    let volumeNumber: Int
    let number: Int
//    let published: String?
//    let length: String?
//    let thumbnail: String?
}
