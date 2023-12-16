//
//  HomeViewModel.swift
//  DeezerClone
//
//  Created by Hakan ERDOĞMUŞ on 1.12.2023.
//

import Foundation

protocol HomeViewModelProtocol {
    var view: HomeViewProtocol? { get set }
    
    func viewDidLoad()
    func getCategory()
    func getNavigateArtistsScreen(id: Int)
    func getTitleName(title: String)
    func getArtistsID(id: Int)
    
}

final class HomeViewModel {
    weak var view: HomeViewProtocol?
    private let service = NetworkManager()
   
    var category: [Datum] = []
    var titleName: String?
    var artistsID: Int?

    
}

extension HomeViewModel: HomeViewModelProtocol {
    
    func viewDidLoad() {
        self.view?.configureVC()
        self.view?.configureCollectionView()
        self.getCategory()
    }
    
    func getTitleName(title: String)  {
        titleName = title
    }
    
    func getArtistsID(id: Int) {
        artistsID = id
    }
    
    
    func getCategory() {

        self.category.removeAll()

        service.downloadHome { [weak self] (returnCategory) in
            guard let self = self else { return }
            guard let returnCategory = returnCategory else { return }

            self.category.append(contentsOf: returnCategory)
            self.view?.reloadCollectionView()
            print(category)
        }
    }

    func getNavigateArtistsScreen(id: Int) {
        service.downloadArtists(id: id) { [weak self] (datum) in
            guard let self = self else { return }
            guard let datum = datum else { return }
            view?.navigateArtistsScreen(artists: datum)
        }
    }
}
