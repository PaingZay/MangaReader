//
//  SearchesManager.swift
//  EZBook
//
//  Created by Paing Zay on 3/12/23.
//

import Foundation

protocol SearchesManagerDelegate {
    func didUpdateSearches(_ searchesManager: SearchesManager, searchedResults: [MangaModel])
    
    func didUpdateSuggestions(_ searchesManager: SearchesManager, suggestions: [SuggestionModel])
    
    func didFailedWithError(error: Error)
}

struct SearchesManager {
    
    let baseAPIPath = "https://kitsu.io/api/edge"
    
    var delegate: SearchesManagerDelegate?
    
    func fetchResults(input: String) {
        let pageLimit = 20
        let pageOffset = 0
        let url = "\(baseAPIPath)/manga??&filter[text]=\(input)&page[limit]=\(pageLimit)&page[offset]=\([pageOffset])"
        

        print("Printing URL\(url)")
        
        performRequest(urlString: url, userInput: input)
    }
    
    func performRequest(urlString: String, userInput: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if let e = error {
                    print(e)
                    return
                }
                if let safeData = data {
                    if let suggestions = self.parseJSONSuggestions(suggestionData: safeData) {
                        
                        for em in suggestions {
                            print("Muda")
                            print("Here are titles\(em.englishTitle)")
                        }
                        
                        let filteredTitles = suggestions.filter { suggestion in
                            if let sug = suggestion.romajiTitle {
                                return sug.lowercased().contains(userInput.lowercased())
                            }
                            return false
                        }

                        for em in filteredTitles {
                            print("Here are filtered titles\(em.englishTitle)")
                        }
                        
                        
                        
                        self.delegate?.didUpdateSuggestions(self, suggestions: filteredTitles)
                    }
                    if let searchedResults = self.parseJSONResults(searchedResultData: safeData) {
                        self.delegate?.didUpdateSearches(self, searchedResults: searchedResults)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSONSuggestions(suggestionData: Data) -> [SuggestionModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(SuggestionData.self, from: suggestionData)
            
            var suggestions: [SuggestionModel] = []
            
            for suggestionData in decodedData.data {
                let id = suggestionData.id
                let englishTitle = suggestionData.attributes.titles.en
                let romajiTitle = suggestionData.attributes.titles.en_jp
                let japaneseTitle = suggestionData.attributes.titles.ja_jp
                
                let suggestion = SuggestionModel(id: id, englishTitle: englishTitle, romajiTitle: romajiTitle, japaneseTitle: japaneseTitle)
                
                
                suggestions.append(suggestion)
            }
            
            return suggestions
            
        } catch {
            print("Error decoding: \(error)")
            return nil
        }
    }
    
    func parseJSONResults(searchedResultData: Data) -> [MangaModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MangaData.self, from: searchedResultData)
            
            var searchedResults: [MangaModel] = []
            
            for searchedResult in decodedData.data {
                let id = searchedResult.id
                let createdAt = searchedResult.attributes.createdAt
                let updatedAt = searchedResult.attributes.updatedAt
                let synopsis = searchedResult.attributes.synopsis
                let description = searchedResult.attributes.description
                let averageRating = searchedResult.attributes.averageRating
                let title = searchedResult.attributes.titles.en_jp
                let coverImage = searchedResult.attributes.coverImage?.original
                let popularityRank = searchedResult.attributes.popularityRank
                let userCount = searchedResult.attributes.userCount
                let favoritesCount = searchedResult.attributes.favoritesCount
                let posterImage = searchedResult.attributes.posterImage.original
                let status = searchedResult.attributes.status
                let chapterCount = searchedResult.attributes.chapterCount
                let volumeCount = searchedResult.attributes.volumeCount
                let serialization = searchedResult.attributes.serialization
                
                let manga = MangaModel(id: id,
                                       createdAt: createdAt,
                                       updatedAt: updatedAt,
                                       synopsis: synopsis,
                                       description: description,
                                       averageRating: averageRating,
                                       title: title,
                                       coverImage: coverImage,
                                       popularityRank: popularityRank,
                                       userCount: userCount,
                                       favoritesCount: favoritesCount,
                                       posterImage: posterImage,
                                       status: status,
                                       chapterCount: chapterCount,
                                       volumeCount: volumeCount,
                                       serialization: serialization
                )

                searchedResults.append(manga)
            }
            
            return searchedResults
            
        } catch {
            print("Error decoding: \(error)")
            return nil
        }
    }
}
