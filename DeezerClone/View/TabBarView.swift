//
//  TabBarView.swift
//  DeezerClone
//
//  Created by Hakan ERDOĞMUŞ on 1.12.2023.
//

import UIKit

class TabBarView: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        self.setupTabs()
        self.selectedIndex = 0
        self.tabBar.backgroundColor = .systemBackground
       // self.tabBar.tintColor = .red
       // self.tabBar.unselectedItemTintColor = .systemBackground
        navigationItem.hidesBackButton = true
        self.tabBarController?.navigationController?.navigationBar.isHidden = true
    }
    //MARK: Tab Setup
    private func setupTabs() {
        let homeView = self.createNavigation(vcTitle: "CATEGORIES 🎼", title: "Categories", image: UIImage(systemName: "list.bullet.circle"), selectedImage: UIImage(systemName: "list.bullet.circle.fill"), vc: HomeView())
        let favoriteView = self.createNavigation(vcTitle: "Favorites", title: "Fav", image: UIImage(systemName: "heart.circle"), selectedImage: UIImage(systemName: "heart.circle.fill"), vc: FavoriteView())
     
        self.setViewControllers([homeView, favoriteView], animated: true)
        
    }
    
    private func createNavigation(vcTitle: String,title: String, image: UIImage?, selectedImage: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.tabBarItem.selectedImage = selectedImage
        nav.viewControllers.first?.navigationItem.title = vcTitle
       // nav.viewControllers.first?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Button", style: .plain, target: nil, action: nil)
        return nav
    }
}
