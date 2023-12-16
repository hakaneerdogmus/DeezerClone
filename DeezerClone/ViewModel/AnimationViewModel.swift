//
//  AnimationViewModel.swift
//  DeezerClone
//
//  Created by Hakan ERDOĞMUŞ on 4.12.2023.
//

import Foundation

protocol AnimationViewModelProtocol {
    var view: AnimationViewProtocol? { get set }
    
    func viewDidLoad()
}

final class AnimationViewModel {
    weak var view: AnimationViewProtocol?
}

extension AnimationViewModel: AnimationViewModelProtocol {
    func viewDidLoad() {
        view?.configureAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.view?.stopAnimation()
            self.view?.pushNavigation()
        }
    }
}
