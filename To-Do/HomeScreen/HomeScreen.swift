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
        
        
    }
}
extension HomeScreen: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
        
        
        
        
//        if let selectedCategory = searchBar.scopeButtonTitles?[selectedScope] {
//            print("What is the Selected Category: \(selectedCategory)")
//            self.selectedCategory = selectedCategory
//            filterContentForSearchText(searchText: searchBar.text ?? "", scope: selectedCategory)
//        }
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
        /*let actionAll = UIAction(title: "Hepsi", image: .all) { _ in
            print("all")
        }
        let actionEducation = UIAction(title: "Eğitim", image: .education) { _ in
            print("Eğitim")
        }
        let actionFun = UIAction(title: "Eğlence", image: .fun) { _ in
            print("Eğlence")
        }
        let actionBusiness = UIAction(title: "İş", image: .business) { _ in
            print("İş")
        }
        let actionRoutine = UIAction(title: "Rutin", image: .routine) { _ in
            print("Rutin")
        }
        let menu = UIMenu(title: "Bilgiler v1.0", children: [actionAll,actionFun,actionRoutine,actionBusiness,actionEducation])
        
        let filterButton = UIBarButtonItem(title: nil, image: .more, primaryAction: nil, menu: menu)
        navigationItem.leftBarButtonItem = filterButton*/
    }
    func filterContentForSearchText(searchText: String, scope: String = "Hepsi") {
        let combinedData = zip(subjectArray, tagArray).map { (subject, tag) in
            return (subject, tag)
        }
        
        filteredToDo = combinedData.filter { (data: (subject: String, tag: String)) -> Bool in
            let doesCategoryMatch = (selectedCategory == "Hepsi") || (data.tag == selectedCategory)

            if isSearchBarEmpty() {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && data.subject.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
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
        if isFiltering() { return filteredToDo.count }
        return subjectArray.count
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
        sourceSubject = subjectArray[indexPath.row]
        sourceId = idArray[indexPath.row]
        
        navigationController?.pushViewController(destinationVC, animated: true)
        destinationVC.targetSubject = sourceSubject
        destinationVC.targetId = sourceId
        
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
