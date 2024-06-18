//
//  Urls.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/18/24.
//

class Urls {
    
    static let baseAPI = "https://api.scripture.api.bible/v1"
    static let apiKey = "ef4a0868a00fde6ad3b3e8cd756022c4"
    
    public enum Api {
        static let bibles = "\(baseAPI)/bibles?language=eng"
        static let books = "\(baseAPI)/bibles/%@/books"
        static let chapters = "\(baseAPI)/bibles/%@/chapters/%@"
    }
}
