//
//  FavoriteViewModel.swift
//  DeezerClone
//
//  Created by Hakan ERDOĞMUŞ on 3.12.2023.
//

import Foundation

protocol FavoriteViewModelProtocol {
    var view: FavoriteViewProtocol? { get set }
    
    func viewDidLoad()
    func viewWillAppear()
    func playSound(sound: String)
    func reloadOnMainThread()
}

final class FavoriteViewModel {
    weak var view: FavoriteViewProtocol?
    private let soundManager = SoundManager()
    
    var songTitle: String?
    var songPreview: String?
    var songDuration: Int?
    var songCover: String?
    var playBool: Bool = false
}

extension FavoriteViewModel: FavoriteViewModelProtocol {
    func viewDidLoad() {
        view?.configureVC()
        view?.configureCollectionView()
    }
    
    func viewWillAppear() {
        view?.viewWillAppear()
    }
    
    func playSound(sound: String) {
        soundManager.playSound(sound: sound)
        playBool.toggle()
        playBool ? soundManager.audioPlayer?.play() : soundManager.audioPlayer?.pause()
    }
    
    func reloadOnMainThread() {
        view?.reloadCollectionView()
    }

}
