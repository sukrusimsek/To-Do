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
    func createCoreData()
}

class HomeScreen: UIViewController {
    var subjectArray = [String]()
    var idArray = [UUID]()
    var sourceSubject = ""
    var sourceId: UUID?
    
    private let viewModel = HomeViewModel()
    private var tableView: UITableView!
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
    func createCoreData() {
        
    }
    /*@objc func createCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for  result in results as! [NSManagedObject] {
                if let subject = result.value(forKey: "subject") as? String {
                    self.subjectArray.append(subject)
                }
                if let if = result.value(forKey: "id") as? UUID {
                    self.idArray.append(id)
                }
                self.tableView.reloadData()
            }
        } catch {
            
     }
    }*/
    
    
}

extension HomeScreen: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
