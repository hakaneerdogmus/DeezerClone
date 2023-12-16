//
//  ArtistsViewModel.swift
//  DeezerClone
//
//  Created by Hakan ERDOĞMUŞ on 1.12.2023.
//

import Foundation

protocol ArtistsViewModelProtocol {
    
    var view: ArtistsViewProtocol? { get set }

    func viewDidLoad()
    func getArtists()
    func getArtistsName(artistsName: String)
    func getArtistsImage(artistsImage: String)
  
}

final class ArtistsViewModel {
    weak var view: ArtistsViewProtocol?
    private let service = NetworkManager()
    
    var artists: [ArtistsData] = []
    var categoryID: Int?
    var artistsName: String?
    var artistsImage: String?
    var artistsID: Int?
}

extension ArtistsViewModel: ArtistsViewModelProtocol {
    func viewDidLoad() {
        view?.configureVC()
        view?.configureCollectionView()
        getArtists()
    }
    
    func getArtistsID(artistsID: Int) {
        self.artistsID = artistsID
    }
    
    func getArtistsImage(artistsImage: String) {
        self.artistsImage = artistsImage
        print("Artists Image: \(artistsImage)")
    }
    
    func getID(id: Int) {
        categoryID = id
    }
    
    func getArtistsName(artistsName: String) {
        self.artistsName = artistsName
        print("Artists Name::: \(artistsName)")
    }
    
    
    func getArtists() {
        self.artists.removeAll()
        service.downloadArtists(id: categoryID!) { [weak self] (returnArtists) in
            guard let self = self else { return }
            guard let returnArtists = returnArtists else { return }
            self.artists.append(contentsOf: returnArtists)
            view?.reloadCollectionView()
            print(artists)
        }
    }
    
    func getNavigateAlbumScreen() {
        view?.navigateAlbumScreen()
    }
}
