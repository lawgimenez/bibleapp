//
//  Urls.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/18/24.
//

class Urls {
    
    static let baseAPI = "https://api.scripture.api.bible/v1"
    static let apiKey = "ef4a0868a00fde6ad3b3e8cd756022c4"
    static let supabaseBaseApi = "https://cllzdzrasqbvrdxiiirl.supabase.co"
    static let supabaseApiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNsbHpkenJhc3FidnJkeGlpaXJsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTg2MTA5OTUsImV4cCI6MjAzNDE4Njk5NX0.3Fi2y_kqTDU0Q2U6hvifYyt14n1O02iYCf9sIqjJV_I"
    
    public enum Api {
        static let bibles = "\(baseAPI)/bibles?language=eng"
        static let books = "\(baseAPI)/bibles/%@/books"
        static let chapters = "\(baseAPI)/bibles/%@/books/%@/chapters"
        static let sections = "\(baseAPI)/bibles/%@/books/%@/sections"
        static let verse = "\(baseAPI)/bibles/%@/verses/%@"
        static let passage = "\(baseAPI)/bibles/%@/passages/%@?content-type=html&include-notes=false&include-titles=true&include-chapter-numbers=false&include-verse-numbers=true&include-verse-spans=false&use-org-id=false"
    }
}
