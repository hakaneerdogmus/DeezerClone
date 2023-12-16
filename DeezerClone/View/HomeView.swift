//
//  HomeView.swift
//  DeezerClone
//
//  Created by Hakan ERDOĞMUŞ on 1.12.2023.
//

import UIKit
import SnapKit


protocol HomeViewProtocol: AnyObject {
    func configureVC()
    func configureCollectionView()
    func reloadCollectionView()
    func navigateArtistsScreen(artists: [ArtistsData])
}
class HomeView: UIViewController {
    private let homeViewModel = HomeViewModel()
    private let artistsViewModel = ArtistsViewModel()
    private var collectionView: UICollectionView!
   // private let realmData = RealmData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel.view = self
        homeViewModel.viewDidLoad()
    }
}
extension HomeView: HomeViewProtocol {
    func configureVC() {
        view.backgroundColor = .orange
        //title = "CATEGORIES 🎼"
        CoreData.shared.favoriteGetCoreData()
        //CoreData.shared.removeAllCoreData()
        //navigationController?.navigationBar.isHidden = true
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
    //MARK: CollectionView
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createFlowLayout())
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: HomeCell.reuseID)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    //MARK: NavigateScreen
    func navigateArtistsScreen(artists: [ArtistsData]) {
        DispatchQueue.main.async {
            let detailArtists = ArtistsView()
            detailArtists.id = self.homeViewModel.artistsID!
            detailArtists.name = self.homeViewModel.titleName ?? "İsim Verisi Gelmedi"
            self.navigationController?.pushViewController(detailArtists, animated: true)
            //MARK: Back Button Title
            self.navigationItem.backButtonTitle = ""
        }
    }
    func reloadCollectionView() {
        collectionView.reloadOnMainThread()
    }
}
extension HomeView: UICollectionViewDataSource, UICollectionViewDelegate {
    //MARK: Count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.category.count
    }
    //MARK: Show
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCell.reuseID, for: indexPath) as! HomeCell
        //İndirilen görseli gösterme komutu yazılacak
        cell.setCell(category: homeViewModel.category[indexPath.item])
        cell.setLabelText(nameCategory: homeViewModel.category[indexPath.item])
        return cell
    }
    //MARK: DidSelect
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        homeViewModel.getNavigateArtistsScreen(id: homeViewModel.category[indexPath.item]._id)
        homeViewModel.getTitleName(title: homeViewModel.category[indexPath.item]._name)
        homeViewModel.getArtistsID(id: homeViewModel.category[indexPath.item]._id)
    }
}
extension UICollectionView {
    func reloadOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
