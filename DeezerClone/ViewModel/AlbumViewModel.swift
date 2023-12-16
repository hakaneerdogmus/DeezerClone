//
//  AlbumViewModel.swift
//  DeezerClone
//
//  Created by Hakan ERDOĞMUŞ on 1.12.2023.
//

import Foundation

protocol AlbumViewModelProtocol {
    var view: AlbumViewProtocol? { get set }
    
    func viewDidLoad()
    func viewWillAppear()
    func getAlbums()
    func getAlbumID(artistsID: Int)
    func playSound(sound: String)
}

final class AlbumViewModel {
    weak var view: AlbumViewProtocol?
    private let service = NetworkManager()
    private let soundManager = SoundManager()
    
    var albums: [AlbumData] = []
    var artistsId: Int?
    var playBool: Bool = false
}
extension AlbumViewModel: AlbumViewModelProtocol {
    func viewDidLoad() {
        view?.configureVC()
        view?.configureArtistsImage()
        view?.configureCollectionView()
        getAlbums()
    }
    func viewWillAppear() {
        view?.viewWillAppear()
    }
    func getAlbumID(artistsID: Int) {
        artistsId = artistsID
    }
    func getAlbums() {
        self.albums.removeAll()
        service.downloadAlbum(artistsId: self.artistsId!) { [weak self] (returnAlbum) in
            guard let self = self else { return }
            guard let returnAlbum = returnAlbum else { return }
            DispatchQueue.main.async {
                self.albums.append(contentsOf: returnAlbum)
                self.view?.reloadCollectionView()
                print(self.albums)
            }
        }
    }
    func playSound(sound: String) {
        soundManager.playSound(sound: sound)
        playBool.toggle()
        playBool ? soundManager.audioPlayer?.play() : soundManager.audioPlayer?.pause()
    }
}
