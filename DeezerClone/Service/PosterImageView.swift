//
//  PosterImageView.swift
//  DeezerClone
//
//  Created by Hakan ERDOĞMUŞ on 1.12.2023.
//

import UIKit
import AlamofireImage
import Alamofire

class PosterImageView: UIImageView {

    private var dataTask: URLSessionDataTask?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func downloadHomeImage(category: Datum) {
        guard let url = URL(string: ApiUrls.imageCategoryUrl(id: category._id)) else { return }
        AF.request(url).responseImage { [weak self] (image) in
            guard let image = image.value else {
                print("Category Download Error")
                return
            }
            DispatchQueue.main.async {
                self?.image = UIImage(cgImage: image.cgImage!)
            }
        }
    }
    
    func downloadArtistsImage(artists: ArtistsData) {
        guard let url = URL(string: ApiUrls.imageArtistsUrl(artistsId: artists._id)) else { return }
        AF.request(url).responseImage { [weak self] (artistsImage) in
            guard let artistsImage = artistsImage.value else {
                print("Artists Image Download Error")
                return
            }
            DispatchQueue.main.async {
                self?.image = UIImage(cgImage: artistsImage.cgImage!)
            }
        }
    }
    
    func downloadArtistsImage(artistsID: Int) {
        guard let url = URL(string: ApiUrls.imageArtistsUrl(artistsId: artistsID)) else { return }
        AF.request(url).responseImage { [weak self] (artistsImage) in
            guard let artistsImage = artistsImage.value else {
                print("Artists Image Download Error")
                return
            }
            DispatchQueue.main.async {
                self?.image = UIImage(cgImage: artistsImage.cgImage!)
            }
        }
    }
    
    func downloadAlbumsImage(albumId: AlbumData) {
        guard let url = URL(string: ApiUrls.imageAlbumsUrl(albumId: albumId.album!._id)) else { return }
        AF.request(url).responseImage { [weak self] (albumImage) in
            guard let albumImage = albumImage.value else {
                print("Albums Image Download Error")
                return
            }
            DispatchQueue.main.async {
                self?.image = UIImage(cgImage: albumImage.cgImage!)
            }
        }
    }
    
    func downloadFavoriteImage(songImage: String) {
        guard let url = URL(string: songImage) else { return }
        AF.request(url).responseImage { [weak self] (albumImage) in
            guard let albumImage = albumImage.value else {
                print("Albums Image Download Error")
                return
            }
            DispatchQueue.main.async {
                self?.image = UIImage(cgImage: albumImage.cgImage!)
            }
        }
    }
    
    func cancelDownloading() {
        dataTask?.cancel()
        dataTask = nil
    }

}
