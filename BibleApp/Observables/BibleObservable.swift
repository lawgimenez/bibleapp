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
    
    @Published var arrayBibles = [Bible]()
    
    func getBibles() async throws {
        let url = URL(string: Urls.Api.bibles)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(Urls.apiKey, forHTTPHeaderField: "api-key")
        let (data, urlResponse) = try await session.data(for: request)
        logger.debug("Bible data: \(data)")
        logger.debug("Bible URL response: \(urlResponse)")
        
    }
}
