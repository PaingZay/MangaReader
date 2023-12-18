//
//  SuggestionModel.swift
//  EZBook
//
//  Created by Paing Zay on 4/12/23.
//

import Foundation

struct SuggestionModel: Codable {
    let id: String
    let englishTitle: String?
    let romajiTitle: String?
    let japaneseTitle: String?
}
