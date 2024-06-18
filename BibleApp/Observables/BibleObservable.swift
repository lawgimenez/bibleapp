//
//  BibleObservable.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/18/24.
//

import Foundation
import OSLog

private let logger = Logger(subsystem: "com.infinalab", category: "BibleObservable")

@MainActor
class BibleObservable: ObservableObject {
    
    @Published var arrayBibles = [Bible.Data]()
    @Published var arrayBooks = [Book.Data]()
    @Published var arrayChapters = [Chapter.Data]()
    @Published var arraySections = [Section.Data]()
    
    func getBibles() async throws {
        let url = URL(string: Urls.Api.bibles)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(Urls.apiKey, forHTTPHeaderField: "api-key")
        let (data, _) = try await session.data(for: request)
        let bibles = try JSONDecoder().decode(Bible.self, from: data)
        arrayBibles = bibles.data
    }
    
    func getBooks(bibleId: String) async throws {
        let booksUrlString = String(format: Urls.Api.books, bibleId)
        let url = URL(string: booksUrlString)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(Urls.apiKey, forHTTPHeaderField: "api-key")
        let (data, _) = try await session.data(for: request)
        let book = try JSONDecoder().decode(Book.self, from: data)
        arrayBooks = book.data
    }
    
    func getChapter(bibleId: String, bookId: String) async throws {
        let chaptersUrlString = String(format: Urls.Api.chapters, bibleId, bookId)
        let url = URL(string: chaptersUrlString)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(Urls.apiKey, forHTTPHeaderField: "api-key")
        let (data, _) = try await session.data(for: request)
        let chapter = try JSONDecoder().decode(Chapter.self, from: data)
        arrayChapters = chapter.data
    }
    
    func getSections(bibleId: String, bookId: String) async throws {
        let chaptersUrlString = String(format: Urls.Api.sections, bibleId, bookId)
        let url = URL(string: chaptersUrlString)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(Urls.apiKey, forHTTPHeaderField: "api-key")
        let (data, urlResponse) = try await session.data(for: request)
        print("Get sections response: \(urlResponse)")
        let section = try JSONDecoder().decode(Section.self, from: data)
        arraySections = section.data
    }
    
    func getVerse(bibleId: String, verseId: String) async throws {
        let verseUrlString = String(format: Urls.Api.verse, bibleId, verseId)
        let url = URL(string: verseUrlString)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(Urls.apiKey, forHTTPHeaderField: "api-key")
        let (data, _) = try await session.data(for: request)
        if let json = try? JSONSerialization.jsonObject(with: data, options: []), let dataDict = json as? NSDictionary {
            print("Verse dict: \(dataDict)")
        }
    }
    
    func getPassage(bibleId: String, anyId: String) async throws {
        let passageUrlString = String(format: Urls.Api.passage, bibleId, anyId)
        let url = URL(string: passageUrlString)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(Urls.apiKey, forHTTPHeaderField: "api-key")
        let (data, _) = try await session.data(for: request)
    }
}
