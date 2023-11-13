//
//  HomeViewModel.swift
//  To-Do
//
//  Created by Şükrü Şimşek on 13.11.2023.
//

import Foundation

protocol HomeViewModelInterface {
    var view: HomeScreenInterface? { get set }
    func viewDidLoad()
    func viewWillAppear()
}

class HomeViewModel {
    weak var view: HomeScreenInterface?
    
}


extension HomeViewModel: HomeViewModelInterface {
    func viewDidLoad() {
        view?.configureVC()
        view?.configureTableView()
        view?.getData()
        
    }
    func viewWillAppear() {
        view?.viewWillCreate()
    }
    
    
}
