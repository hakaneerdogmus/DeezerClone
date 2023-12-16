//
//  FavoriteView.swift
//  DeezerClone
//
//  Created by Hakan ERDOĞMUŞ on 1.12.2023.
//

import UIKit
//MARK: FavoriteViewProtocol
protocol FavoriteViewProtocol: AnyObject {
    func configureVC()
    func configureCollectionView()
    func viewWillAppear()
    func reloadCollectionView()
}
//MARK: FavoriteView
class FavoriteView: UIViewController {
    private let favoriteViewMdel = FavoriteViewModel()
    private let albumViewModel = AlbumViewModel()
    
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteViewMdel.view = self
        favoriteViewMdel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoriteViewMdel.viewWillAppear()
    }
}

extension FavoriteView: FavoriteViewProtocol {
    func configureVC() {
        view.backgroundColor = .systemBackground
        //tracking changing data
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoriteStatusDidChange), name: .favoriteStatusDidChange, object: nil)
    }
    //MARK: Reload CollectionView
    @objc func handleFavoriteStatusDidChange() {
            // Favori durumu değişti, collectionView'ı güncelle
            collectionView.reloadData()
        }
    
    func viewWillAppear() {
       // CoreData.shared.getCoreData()
        CoreData.shared.favoriteGetCoreData()
        reloadCollectionView()
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
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: FavoriteCell.reuseID)
        collectionView.snp.makeConstraints { make in
            make.width.bottom.equalToSuperview()
           // make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    func reloadCollectionView() {
        collectionView.reloadOnMainThread()
    }
}

//MARK: Favorite CollectionView
extension FavoriteView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CoreData.shared.songIdArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.reuseID, for: indexPath) as! FavoriteCell
        cell.setImageCell(songImage: CoreData.shared.songImageArray[indexPath.item])
        cell.setSongName(songName: CoreData.shared.songTitleArray[indexPath.item])
        cell.setSongDuration(songTime: CoreData.shared.songDurationArray[indexPath.item])
        cell.setFavIcon(songId: CoreData.shared.songIdArray[indexPath.item])
        cell.setCoreData(songId: CoreData.shared.songIdArray[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        favoriteViewMdel.playSound(sound: CoreData.shared.songPreview[indexPath.item])
    }
}


