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
    
    func getBibles() async throws {
        let url = URL(string: Urls.Api.bibles)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(Urls.apiKey, forHTTPHeaderField: "api-key")
        let (data, urlResponse) = try await session.data(for: request)
        print(urlResponse)
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
    
    func getChapter(bibleId: String, chapterId: String) async throws {
        let chaptersUrlString = String(format: Urls.Api.chapters, bibleId, chapterId)
        let url = URL(string: chaptersUrlString)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(Urls.apiKey, forHTTPHeaderField: "api-key")
        let (data, _) = try await session.data(for: request)
        let chapter = try JSONDecoder().decode(Chapter.self, from: data)
        print("Chapter: \(chapter.data)")
    }
}
