//
//  ArtistsView.swift
//  DeezerClone
//
//  Created by Hakan ERDOĞMUŞ on 1.12.2023.
//

import UIKit
import SnapKit

protocol ArtistsViewProtocol: AnyObject {
    func configureVC()
    func configureCollectionView()
    func reloadCollectionView()
    func navigateAlbumScreen()
}

final class ArtistsView: UIViewController {

    private let artistsViewModel = ArtistsViewModel()
    private var collectionView: UICollectionView!
    
    var name: String = ""
    var id: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        artistsViewModel.view = self
        artistsViewModel.viewDidLoad()
    }
}

extension ArtistsView: ArtistsViewProtocol {
   
    func configureVC() {
        view.backgroundColor = .systemBackground
        title = name
        artistsViewModel.getID(id: id)
    }
    
    //MARK: CollectionView layout cellerin gözükne ayarı
    func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        //CollectionView in dikey olarak scroll edilebilir olduğunu belirttik
        layout.scrollDirection = .vertical
        //Saüdan soldan üsttten alltan bırakılan boşluk ayarı
        layout.sectionInset = UIEdgeInsets(top: 30, left: 10, bottom: 0, right: 10)
        //Herbir hücre için ayar geniişilk ayarı ile yan yana 2 tane cel görünmesini ayarladık
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 15 , height: UIScreen.main.bounds.width * 0.5)
        //Aradaki boşluklar Yatay yani alt alta olan cellerin mesafe boşlukları
       // layout.minimumLineSpacing = 25
        return layout
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createFlowLayout())
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ArtistsCell.self, forCellWithReuseIdentifier: ArtistsCell.reuseID)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    //MARK: NavigateAlbumScreen
    func navigateAlbumScreen() {
        DispatchQueue.main.async {
            let album = AlbumView()
            album.artistsName = self.artistsViewModel.artistsName ?? "Dont ArtistsName "
            album.artistsImage = self.artistsViewModel.artistsImage ?? "Dont Image"
            album.artistsID = self.artistsViewModel.artistsID!
            self.navigationController?.pushViewController(album, animated: true)
            //MARK: Back Button Title
            self.navigationItem.backButtonTitle = ""
        }
    }
    
    func reloadCollectionView() {
        collectionView.reloadOnMainThread()
    }
}

extension ArtistsView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artistsViewModel.artists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistsCell.reuseID, for: indexPath) as! ArtistsCell
        cell.setCell(artistsImage: artistsViewModel.artists[indexPath.item])
        cell.setLabelText(nameArtists: artistsViewModel.artists[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        artistsViewModel.getNavigateAlbumScreen()
        artistsViewModel.getArtistsName(artistsName: artistsViewModel.artists[indexPath.item]._name)
        artistsViewModel.getArtistsImage(artistsImage: artistsViewModel.artists[indexPath.item]._picture)
        artistsViewModel.getArtistsID(artistsID: artistsViewModel.artists[indexPath.item]._id)
    }
}

