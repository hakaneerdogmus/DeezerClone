//
//  NetworkManager.swift
//  DeezerClone
//
//  Created by Hakan ERDOĞMUŞ on 1.12.2023.
//

import Foundation
import Alamofire


class NetworkManager {
    
    static let shared = NetworkManager()
    
    func downloadHome(completion: @escaping ([Datum]?) -> Void ) {
        guard let url = URL(string: ApiUrls.homeUrl()) else { return }
        AF.request(url).responseDecodable(of: HomeModel.self) { [weak self] (model) in
            guard let data = model.value else {
                completion(nil)
                print("Home Download Error")
                return
            }
            completion(data.data)
        }
    }
    
    func downloadDatum(completion: @escaping (Datum?) -> ()) {
        guard let url = URL(string: ApiUrls.homeUrl()) else { return }
        AF.request(url).responseDecodable(of: Datum.self) { [weak self] (result) in
            guard let result = result.value else {
                completion(nil)
                print("Datum Download Error")
                return
            }
            completion(result)
        }
    }
    
    func downloadArtists(id: Int, completion: @escaping ([ArtistsData]?) -> Void) {
        
        guard let url = URL(string: ApiUrls.artistsUrl(id: id)) else { return }
        
        AF.request(url).responseDecodable(of: ArtistsModel.self) { [weak self] (artists) in
            guard let data = artists.value else {
                completion(nil)
                print("Artists Download Error")
                return
            }
            completion(data.data)
        }
    }
    
    func downloadAlbum(artistsId: Int, completion: @escaping ([AlbumData]?) -> Void) {
        guard let url = URL(string: ApiUrls.albumsUrl(artistsId: artistsId)) else { return }
        AF.request(url).responseDecodable(of: AlbumModel.self) { [weak self] (album) in
            guard let data = album.value else {
                completion(nil)
                print("Albums Download Error")
                return
            }
            completion(data.data)
        }
    }
}
