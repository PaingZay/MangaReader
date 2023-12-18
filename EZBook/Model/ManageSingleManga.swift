//
//  FetchSingleItem.swift
//  EZBook
//
//  Created by Paing Zay on 1/12/23.
//

import Foundation

protocol SingleMangaDelegate {
    func didRetrieveManga(_ manageSingleManga: ManageSingleManga, manga: MangaModel)
    func didFailedWithError(error: Error)
}

struct ManageSingleManga {
    let baseAPIPath = "https://kitsu.io/api/edge"
    
    var delegate: SingleMangaDelegate?
    
    func fetchManga(id: String) {
        let pageLimit = 20
        let pageOffset = 0
        
        let url = "\(baseAPIPath)/manga/\(id)?page[limit]=\(pageLimit)&page[offset]=\(pageOffset)"
        
        performRequest(urlString: url)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string:  urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let e = error {
                    print(e)
                    return
                }
                if let safeData = data {
                    if let manga = self.parseJSON(mangaData: safeData) {
                        self.delegate?.didRetrieveManga(self, manga: manga)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(mangaData: Data) -> MangaModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(SingleMangaData.self, from: mangaData)
            
            let manga = decodedData.data
            
            let id = manga.id
            let createdAt = manga.attributes.createdAt
            let updatedAt = manga.attributes.updatedAt
            let synopsis = manga.attributes.synopsis
            let description = manga.attributes.description
            let averageRating = manga.attributes.averageRating
            let title = manga.attributes.titles.en_jp
            let coverImage = manga.attributes.coverImage?.original
            let popularityRank = manga.attributes.popularityRank
            let userCount = manga.attributes.userCount
            let favoritesCount = manga.attributes.favoritesCount
            let posterImage = manga.attributes.posterImage.original
            let status = manga.attributes.status
            let chapterCount = manga.attributes.chapterCount
            let volumeCount = manga.attributes.volumeCount
            let serialization = manga.attributes.serialization

            return MangaModel(id: id,
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
            
        } catch {
            print("MUDA\(error)")
            return nil
        }
    }
}
