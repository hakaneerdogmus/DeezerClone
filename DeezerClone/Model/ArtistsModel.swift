//
//  ArtistsModel.swift
//  DeezerClone
//
//  Created by Hakan ERDOĞMUŞ on 1.12.2023.
//

import Foundation

struct ArtistsModel: Decodable {
    
    let data: [ArtistsData]?
}

struct ArtistsData: Decodable {
    
    let id: Int?
    let name: String?
    let picture: String?
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case name, picture
    }
    
    var _id: Int {
        id ?? Int.min
    }
    
    var _name: String {
        name ?? "N/A"
    }
    
    var _picture: String {
        picture ?? ""
    }
}
