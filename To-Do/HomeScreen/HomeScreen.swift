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
    func getData()
    func viewWillCreate()
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
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
    @objc func getData() {
        self.subjectArray.removeAll(keepingCapacity: true)
        self.idArray.removeAll(keepingCapacity: true)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let subject = result.value(forKey: "subject") as? String {
                    self.subjectArray.append(subject)
                    
                }
                if let id = result.value(forKey: "id") as? UUID {
                    self.idArray.append(id)
                    
                }
                self.tableView.reloadData()
                    
            }
            
        } catch  {
            
        }
    }
    func viewWillCreate() {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name.init(rawValue: "newData"), object: nil)
        

    }
    
    
}

extension HomeScreen: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjectArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = subjectArray[indexPath.row]
        return cell
        
    }
    
    
}
