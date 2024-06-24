//
//  BibleObservable.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/18/24.
//

import Foundation
import OSLog
import SwiftData

private let logger = Logger(subsystem: "com.infinalab", category: "BibleObservable")

@MainActor
class BibleObservable: ObservableObject {
    
    @Published var arrayBibles = [Bible.Data]()
    @Published var arrayBooks = [Book.Data]()
    @Published var arrayChapters = [Chapter.Data]()
    @Published var arraySections = [Section.Data]()
    @Published var passage: Passage.Data?
    @Published var passageContent: String = ""
    
    func getBibles(modelContext: ModelContext) async throws {
        let url = URL(string: Urls.Api.bibles)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(Urls.apiKey, forHTTPHeaderField: "api-key")
        let (data, _) = try await session.data(for: request)
        let bibles = try JSONDecoder().decode(Bible.self, from: data)
        // Insert data
        for bible in bibles.data {
            let bibleData = BibleData(id: bible.id, dblId: bible.dblId, abbreviation: bible.abbreviation, abbreviationLocal: bible.abbreviationLocal, name: bible.name, nameLocal: bible.nameLocal, description: bible.description ?? "", descriptionLocal: bible.descriptionLocal ?? "", type: bible.type)
            modelContext.insert(bibleData)
        }
        do {
            try modelContext.save()
        } catch {
            print("Bible data error: \(error)")
        }
        arrayBibles = bibles.data
    }
    
    func getBooks(bibleId: String, modelContext: ModelContext) async throws {
        let booksUrlString = String(format: Urls.Api.books, bibleId)
        let url = URL(string: booksUrlString)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(Urls.apiKey, forHTTPHeaderField: "api-key")
        let (data, _) = try await session.data(for: request)
        let books = try JSONDecoder().decode(Book.self, from: data)
        // Insert data
        for book in books.data {
            let bookData = BookData(id: book.id, bibleId: book.bibleId, abbreviation: book.abbreviation, name: book.name, nameLong: book.nameLong)
            modelContext.insert(bookData)
        }
        do {
            try modelContext.save()
        } catch {
            print("Book data error: \(error)")
        }
        arrayBooks = books.data
    }
    
    func getChapter(bibleId: String, bookId: String, modelContext: ModelContext) async throws {
        let chaptersUrlString = String(format: Urls.Api.chapters, bibleId, bookId)
        let url = URL(string: chaptersUrlString)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(Urls.apiKey, forHTTPHeaderField: "api-key")
        let (data, _) = try await session.data(for: request)
        let chapters = try JSONDecoder().decode(Chapter.self, from: data)
        // Insert data
        for chapter in chapters.data {
            let chapterData = ChapterData(id: chapter.id, bibleId: chapter.bibleId, number: chapter.number, bookId: chapter.bookId, content: chapter.content ?? "", reference: chapter.reference, verseCount: chapter.verseCount ?? 0)
            modelContext.insert(chapterData)
        }
        do {
            try modelContext.save()
        } catch {
            print("Chapter data error: \(error)")
        }
        arrayChapters = chapters.data
    }
    
    func getPassage(bibleId: String, anyId: String, modelContext: ModelContext) async throws {
        let chapterId = anyId.replacingOccurrences(of: ".intro", with: "", options: .literal)
        let passageUrlString = String(format: Urls.Api.passage, bibleId, chapterId)
        let url = URL(string: passageUrlString)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(Urls.apiKey, forHTTPHeaderField: "api-key")
        let (data, urlResponse) = try await session.data(for: request)
        print("Passage URL response: \(urlResponse)")
        let passage = try JSONDecoder().decode(Passage.self, from: data).data
        // Insert data
        let passageData = PassageData(id: passage.id, orgId: passage.orgId, bibleId: passage.bibleId, bookId: passage.bookId, chapterId: anyId, reference: passage.reference, content: passage.content, copyright: passage.copyright)
        modelContext.insert(passageData)
        do {
            try modelContext.save()
        } catch {
            print("Passage data error: \(error)")
        }
        self.passage = passage
        self.passageContent = passage.content
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
}
