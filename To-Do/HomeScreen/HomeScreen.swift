//
//  HomeScreen.swift
//  To-Do
//
//  Created by Şükrü Şimşek on 13.11.2023.
//

import UIKit
import CoreData

protocol HomeScreenInterface: AnyObject {
    func configureVC()
    func configureTableView()
}

class HomeScreen: UIViewController {
    var subjectArray = [String]()
    var idArray = [UUID]()
    var sourceSubject = ""
    var sourceId: UUID?
    
    private let viewModel = HomeViewModel()
    private var tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.view = self
        viewModel.viewDidLoad()
        viewModel.viewWillAppear()
        

    }
}

extension HomeScreen: HomeScreenInterface {
    func configureVC() {
        title = "To-Do"
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addItem))
    }
    func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGray4
        tableView.pinToEdgesOf(view: view)
        
        //tableView. register
        
    }
    @objc func addItem() {
        navigationController?.pushViewController(DetailScreen(), animated: true)
    }
}

extension HomeScreen: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Hello"
        //nameArray[indexPath.row]
        return cell
        
    }
    
    
}
