//
//  AlbumModel.swift
//  DeezerClone
//
//  Created by Hakan ERDOĞMUŞ on 1.12.2023.
//

import Foundation

struct AlbumModel: Decodable {
    
    let data: [AlbumData]?
}

struct AlbumData: Decodable {
    
    let id: Int?
    let title: String?
    let duration: Int?
    let preview: String?
    let album: Album?
    
    enum CodingKeys: String, CodingKey {
        case id, duration
        case title
        case album
        case preview
    }
    
    var _songId: Int {
        id ?? Int.min
    }
    var _songTitle: String {
        title ?? "Song Title"
    }
    var _songDuration: Int {
        duration ?? Int.min
    }
    var _preview: String {
        preview ?? "preview"
    }
}

struct Album: Decodable {
    
    let id: Int?
    let title: String?
    let cover: String?
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case title, cover
    }
    
    var _id: Int {
        id ?? Int.min
    }
    
    var _title: String {
        title ?? "N/A"
    }
    
    var _cover: String {
        cover ?? ""
    }
}
