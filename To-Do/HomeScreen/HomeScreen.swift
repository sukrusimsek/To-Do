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
    func configureSearchCont()
    func filterContentForSearchText(searchText: String, scope: String)
    func isSearchBarEmpty() -> Bool
    func isFiltering() -> Bool
    func filterData(by category: String)
    func showAllData()
}

final class HomeScreen: UIViewController {
    var subjectArray = [String]()
    var idArray = [UUID]()
    var tagArray = [String]()
    var sourceSubject = ""
    var sourceId: UUID?
    var sourceTag = ""
    var initialSubjectArray: [String] = []
    var initialIdArray: [UUID] = []
    var initialTagArray: [String] = []
    
    var selectedCategory = "Hepsi"
    var filteredToDo = [(String, String)]()
    private let viewModel = HomeViewModel()
    private var tableView = UITableView()
    private var searchController = UISearchController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.view = self
        viewModel.viewDidLoad()
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.viewWillAppear()
        tableView.reloadData()
        
    }
}
extension HomeScreen: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.view?.filterContentForSearchText(searchText: searchText, scope: "Hepsi")
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsScopeBar = true
        searchBar.sizeToFit()
        return true
    }
}
extension HomeScreen: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searchController.searchBar.text!, scope: scope)

    }
}
extension HomeScreen: HomeScreenInterface {
    func configureVC() {
        title = "To-Do 📚"
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addItem))

    }
    func filterContentForSearchText(searchText: String, scope: String = "Hepsi") {
        let combinedData = zip(subjectArray, tagArray).map { (subject, tag) in
            return (subject, tag)
        }
        
        
        filteredToDo = combinedData.filter { (data: (subject: String, tag: String)) -> Bool in
            let doesCategoryMatch = (scope == "Hepsi") || (data.tag == scope)
            
            if isSearchBarEmpty() {
                return doesCategoryMatch
            }
            return doesCategoryMatch && data.tag.lowercased().contains(searchText.lowercased())
        }
        

        tableView.reloadData()
        

    }
    func showAllData() {
        subjectArray = initialSubjectArray
        tagArray = initialTagArray
        idArray = initialIdArray
        
        tableView.reloadData()
    }
    func filterData(by category: String) {
         if category == "Hepsi" {
             showAllData()
         } else {
             
         let filteredData = zip(subjectArray, tagArray).compactMap { (subject, tag) in
         return tag == category ? subject : nil
         }
         subjectArray = filteredData
         tagArray = Array(repeating: category, count: filteredData.count)

            
        tableView.reloadData()
        }
    }
    func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        
        return searchController.isActive && (!isSearchBarEmpty() || searchBarScopeIsFiltering)
        
    }
    
    func configureSearchCont() {
        navigationItem.searchController = searchController
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search To-Do Type"
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.scopeButtonTitles = ["Hepsi", "Eğitim", "Eğlence", "İş", "Rutin"]
        searchController.searchBar.delegate = self
        searchController.searchBar.becomeFirstResponder()
        searchController.definesPresentationContext = true
        
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
        subjectArray = initialSubjectArray
        tagArray = initialTagArray
        idArray = initialIdArray
        
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
        if isFiltering() { return filteredToDo.count }
        return tagArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoCell.resueId,for: indexPath) as! ToDoCell
        
        
        
        let currentData: (subject: String, tag: String)
        
        if isFiltering() {
            
            currentData = filteredToDo[indexPath.row]
            
         } else {
             currentData = (subject: subjectArray[indexPath.row], tag: tagArray[indexPath.row])
             
         }
        
        cell.tagLabel.text = currentData.tag
        cell.textLabel?.text = currentData.subject
        
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
                cell.tagLabel.backgroundColor = .systemGray6
                break
            }
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = DetailScreen()
            
        var dataToPass: (subject: String, id: UUID)

        if isFiltering() {
            let selectedData = filteredToDo[indexPath.row]
            if let selectedIndex = subjectArray.firstIndex(of: selectedData.0) {
                dataToPass = (subject: selectedData.0, id: idArray[selectedIndex])
                } else {
                print("Handle the error")
                return
            }
           } else {
               dataToPass = (subject: subjectArray[indexPath.row], id: idArray[indexPath.row])
           }
            
        navigationController?.pushViewController(destinationVC, animated: true)
            
        destinationVC.targetSubject = dataToPass.subject
        destinationVC.targetId = dataToPass.id
        
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //Delete
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
                    
                    if isFiltering() {
                        let selectedData = filteredToDo[indexPath.row]
                        if let selectedIndex = tagArray.firstIndex(of: selectedData.1) {
                            subjectArray.remove(at: selectedIndex)
                            idArray.remove(at: selectedIndex)
                            tagArray.remove(at: selectedIndex)
                            }
                        filteredToDo.remove(at: indexPath.row)
                    } else {
                        subjectArray.remove(at: indexPath.row)
                        idArray.remove(at: indexPath.row)
                        tagArray.remove(at: indexPath.row)
                    }
                    self.tableView.reloadData()
                    
                    do {
                        try context.save()
                    } catch  {
                        print("Error")
                    }
                    tableView.reloadData()
                }
            }
        } catch  {
            
        }
    }
    
}
