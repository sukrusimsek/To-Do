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

final class HomeScreen: UIViewController {
    var subjectArray = [String]()
    var idArray = [UUID]()
    var tagArray = [String]()
    var sourceSubject = ""
    var sourceId: UUID?
    var sourceTag = ""
    
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
        title = "To-Do 📚"
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addItem))
    }
    func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ToDoCell.self, forCellReuseIdentifier: ToDoCell.resueId)
        tableView.backgroundColor = .systemGray4
        tableView.pinToEdgesOf(view: view)
        
        
    }
    @objc func addItem() {
        sourceSubject = ""
        navigationController?.pushViewController(DetailScreen(), animated: true)
    }
    @objc func getData() {
        self.subjectArray.removeAll(keepingCapacity: true)
        self.idArray.removeAll(keepingCapacity: true)
        self.tagArray.removeAll(keepingCapacity: true)
        
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
                if let tag = result.value(forKey: "tag") as? String {
                    self.tagArray.append(tag)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoCell.resueId,for: indexPath) as! ToDoCell
        cell.tagLabel.text = tagArray[indexPath.row]
        cell.textLabel?.text = subjectArray[indexPath.row]
        
        if let tagText = cell.tagLabel.text {
            switch tagText {
            case "Eğlence":
                cell.tagLabel.backgroundColor = .systemGreen
            case "İş":
                cell.tagLabel.backgroundColor = .systemPink
            case "Rutin":
                cell.tagLabel.backgroundColor = .systemYellow
            case "Eğitim":
                cell.tagLabel.backgroundColor = .systemIndigo
            default:
                cell.tagLabel.backgroundColor = .systemFill
                break
            }
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = DetailScreen()
        sourceSubject = subjectArray[indexPath.row]
        sourceId = idArray[indexPath.row]
        navigationController?.pushViewController(destinationVC, animated: true)
        destinationVC.targetSubject = sourceSubject
        destinationVC.targetId = sourceId
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        let idString = idArray[indexPath.row].uuidString
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let _ = result.value(forKey: "id") as? UUID {
                    context.delete(result)
                    subjectArray.remove(at: indexPath.row)
                    idArray.remove(at: indexPath.row)
                    tagArray.remove(at: indexPath.row)
                    self.tableView.reloadData()
                    
                    do {
                        try context.save()
                    } catch  {
                        print("Error")
                    }
                }
            }
        } catch  {
            
        }
    }
    
    
}
