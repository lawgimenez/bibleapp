//
//  Bible.swift
//  BibleApp
//
//  Created by Lawrence Gimenez on 6/18/24.
//

struct Bible: Decodable {

    var data: [Data]

    struct Data: Decodable, Identifiable {

        var id: String
        var dblId: String
        var abbreviation: String
        var abbreviationLocal: String
        var name: String
        var nameLocal: String
        var description: String?
        var descriptionLocal: String?
        var type: String
    }

}
