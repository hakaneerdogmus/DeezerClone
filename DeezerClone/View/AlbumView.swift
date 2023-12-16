//
//  AlbumView.swift
//  DeezerClone
//
//  Created by Hakan ERDOĞMUŞ on 1.12.2023.
//

import UIKit
import SnapKit

//MARK: AlbumViewProtocol
protocol AlbumViewProtocol: AnyObject {
    func configureVC()
    func configureArtistsImage()
    func configureCollectionView()
    func reloadCollectionView()
    func viewWillAppear()
}
//MARK: AlbumView Controller
class AlbumView: UIViewController {
    private let albumViewModel = AlbumViewModel()
    private var posterImageView: PosterImageView!
    private var artistsImageView: UIImageView!
    private var collectionView: UICollectionView!
    
    var artistsName: String = ""
    var artistsImage: String = ""
    var artistsID: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumViewModel.view = self
        albumViewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        albumViewModel.viewWillAppear()
    }
}

extension AlbumView: AlbumViewProtocol {
    func configureVC() {
        view.backgroundColor = .systemBackground
        title = artistsName
        albumViewModel.getAlbumID(artistsID: artistsID)
    }
    func viewWillAppear() {
        CoreData.shared.favoriteGetCoreData()
        collectionView.reloadData()
    }
    //MARK: Artist Image Setting
    func configureArtistsImage() {
        posterImageView = PosterImageView(frame: .zero)
        view.addSubview(posterImageView)
        posterImageView.downloadArtistsImage(artistsID: artistsID)
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.height * 0.25)
            make.width.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    //MARK: CollectionView layout cells view setting
    func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        //CollectionView in dikey olarak scroll edilebilir olduğunu belirttik
        layout.scrollDirection = .vertical
        //Saüdan soldan üsttten alltan bırakılan boşluk ayarı
        layout.sectionInset = UIEdgeInsets(top: 30, left: 10, bottom: 0, right: 10)
        //Herbir hücre için ayar geniişilk ayarı ile yan yana 2 tane cel görünmesini ayarladık
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width  , height: UIScreen.main.bounds.width * 0.25)
        //Aradaki boşluklar Yatay yani alt alta olan cellerin mesafe boşlukları
        // layout.minimumLineSpacing = 25
        return layout
    }
    //MARK: CollectionView View Setting
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createFlowLayout())
        view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(AlbumCell.self, forCellWithReuseIdentifier: AlbumCell.reuseID)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(5)
            make.left.right.bottom.equalToSuperview()
        }
    }
    //MARK: Reload Collection
    func reloadCollectionView() {
        collectionView.reloadOnMainThread()
    }
}
//MARK: Album CollectionView
extension AlbumView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumViewModel.albums.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCell.reuseID, for: indexPath) as! AlbumCell
        cell.setCell(albumId: albumViewModel.albums[indexPath.item])
        cell.setAlbumName(albumData: albumViewModel.albums[indexPath.item])
        cell.setSongDuration(songTime: albumViewModel.albums[indexPath.item])
        cell.favIcon(albumData: albumViewModel.albums[indexPath.item])
        cell.setCoreData(albumData: albumViewModel.albums[indexPath.item])
        return cell
    }
    //MARK: DidSelect
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        albumViewModel.playSound(sound: albumViewModel.albums[indexPath.item]._preview)
    }
}
