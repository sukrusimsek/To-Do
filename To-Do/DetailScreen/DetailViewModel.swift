//
//  DetailViewModel.swift
//  To-Do
//
//  Created by Şükrü Şimşek on 13.11.2023.
//

import Foundation

protocol DetailViewModelInterface {
    var view: DetailScreenInterface? { get set }
    func viewDidLoad()
    
}

class DetailViewModel {
    weak var view: DetailScreenInterface?
    
}

extension DetailViewModel: DetailViewModelInterface {
    func viewDidLoad() {
        view?.configureVC()
        view?.configureTag()
        view?.configureSubject()
        view?.configureDesc()
        view?.configureButton()
        
    }
}
