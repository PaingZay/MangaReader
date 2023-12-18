//
//  ManageChapter.swift
//  EZBook
//
//  Created by Paing Zay on 2/12/23.
//

import Foundation

protocol ChapterManagerDelegate {
    func didUpdateChapters(_ chapterManager: ChapterManager, chapters:[ChapterModel])
    func didFailedWithErrors(error: Error)
}

struct ChapterManager {
    let baseAPIPath = "https://kitsu.io/api/edge"
    
    var delegate: ChapterManagerDelegate?
    
    func fetchChapters(mangaId: String) {
        let pageLimit = 20
        let pageOffset = 0
        let url = "\(baseAPIPath)/manga/\(mangaId)/chapters?page[limit]=\(pageLimit)&page[offset]=\(pageOffset)"
        
        performRequest(urlString: url)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if let e = error {
                    print(e)
                    return
                }
                if let safeData = data {
                    if let chapters = self.parseJSON(chapterData: safeData) {
                        self.delegate?.didUpdateChapters(self, chapters: chapters)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(chapterData: Data) -> [ChapterModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ChapterData.self, from: chapterData)
            
            var chapters: [ChapterModel] = []
            
            for chapter in decodedData.data {
                let id = chapter.id
                let number = chapter.attributes.number
                let volumeNumber = chapter.attributes.volumeNumber
                
                let chapter = ChapterModel(id: id, volumeNumber: volumeNumber, number: number)
                
                chapters.append(chapter)
            }
            return chapters
            
        } catch {
            print(error)
            return nil
        }
    }
}
