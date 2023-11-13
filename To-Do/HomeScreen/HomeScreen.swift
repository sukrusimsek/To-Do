//
//  HomeScreen.swift
//  To-Do
//
//  Created by Şükrü Şimşek on 13.11.2023.
//

import UIKit

protocol HomeScreenInterface: AnyObject {
    func configureVC()
    func configureTableView()
}

class HomeScreen: UIViewController {
   
    
    private let viewModel = HomeViewModel()
    private var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.view = self
        viewModel.viewDidLoad()
        

    }
}

extension HomeScreen: HomeScreenInterface {
    func configureVC() {
        title = "To-Do"
    }
    func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGray4
        
    }
    
    
}

extension HomeScreen: UITableViewDelegate, UITableViewDataSource {
    
}
