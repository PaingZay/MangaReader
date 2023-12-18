//
//  File.swift
//  EZBook
//
//  Created by Paing Zay on 23/11/23.
//

import Foundation

protocol MangaDelegate {
    func didUpdatePopularMangas(_ mangaManager: MangaManager, mangas:[MangaModel])
    func didUpdateHighRatedMangas(_ mangaManager: MangaManager, mangas:[MangaModel])
    func didUpdateRecentRelease(_ magaManager: MangaManager, mangas:[MangaModel])
    func didFailedWithError(error: Error)
}

struct MangaManager {
    
    enum filterOption {
            case highestRated
            case mostPopular
            case recentRelease
        }
    
    let baseAPIPath = "https://kitsu.io/api/edge"
    
    var delegate: MangaDelegate?
    
    func fetchBooks(filter: filterOption) {
        let pageLimit = 20
        let pageOffset = 0
        var url = "\(baseAPIPath)/manga?page[limit]=\(pageLimit)&page[offset]=\(pageOffset)"
        
            switch filter {
            case .highestRated:
            url = "\(url)&sort=-averageRating"
            
            case .mostPopular:
            url = "\(url)&sort=-userCount"
                
            case .recentRelease:
                url = "\(url)&sort=updatedAt"
            }
        performRequest(urlString: url, filter:filter)
    }

    func performRequest(urlString: String, filter:filterOption) {
    if let url = URL(string: urlString) {
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            if let e = error {
                print(e)
                return
            }
            if let safeData = data {
                if let mangas = self.parseJSON(mangaData: safeData) {
                    switch filter {
                            case .highestRated:
                            print("I am highest")
                            self.delegate?.didUpdateHighRatedMangas(self, mangas: mangas)
                        
                            case .mostPopular:
                            print("I am popular")
                            self.delegate?.didUpdatePopularMangas(self, mangas: mangas)
                        
                            case .recentRelease:
                            print("I am recent release")
                            self.delegate?.didUpdateRecentRelease(self, mangas: mangas)
                    }
                }
                //Requires default
            }
        }
        task.resume()
    }
}

func parseJSON(mangaData: Data) -> [MangaModel]? {
    let decoder = JSONDecoder()
    do {
        
        let decodedData = try decoder.decode(MangaData.self, from: mangaData)
        
        var mangas: [MangaModel] = []
        
        for manga in decodedData.data {
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

            mangas.append(manga)
        }
        return mangas
    } catch {
        print("MUDA\(error)")
        return nil
    }
}

}
