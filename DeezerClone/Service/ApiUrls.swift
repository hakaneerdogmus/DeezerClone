//
//  ApiUrls.swift
//  DeezerClone
//
//  Created by Hakan ERDOĞMUŞ on 1.12.2023.
//

import Foundation

enum ApiUrls {
    
    static func homeUrl() -> String {
        return "https://api.deezer.com/genre"
    }
    static func imageCategoryUrl(id: Int) -> String {
        return "https://api.deezer.com/genre/\(id)/image"
    }
    static func artistsUrl(id: Int) -> String {
        return "https://api.deezer.com/genre/\(id)/artists"
    }
    static func imageArtistsUrl(artistsId: Int) -> String {
        return "https://api.deezer.com/artist/\(artistsId)/image"
    }
    static func albumsUrl(artistsId: Int) -> String {
        return "https://api.deezer.com/artist/\(artistsId)/top?limit=50"
    }
    static func imageAlbumsUrl(albumId: Int) -> String {
        return "https://api.deezer.com/album/\(albumId)/image"
    }
}
