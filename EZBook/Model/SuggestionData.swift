//
//  SuggestionData.swift
//  EZBook
//
//  Created by Paing Zay on 4/12/23.
//

import Foundation

/*SUGGESTIONS*/

struct SuggestionData: Codable {
    let data: [Suggestion]
}

struct SingleSuggestionData: Codable {
    let data: Suggestion
}

struct Suggestion: Codable {
    let id: String
    let attributes: SuggestionAttributes
}

struct SuggestionAttributes: Codable {
    let titles: MangaTitles
}
