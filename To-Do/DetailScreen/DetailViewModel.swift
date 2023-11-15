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

final class DetailViewModel {
    weak var view: DetailScreenInterface?
    
}

extension DetailViewModel: DetailViewModelInterface {
    func viewDidLoad() {
        view?.configureVC()
        view?.configureSubject()
        view?.configureTag()
        view?.configureDesc()
        view?.configureButton()
        view?.checkTarget()
        
    }
}
