//
//  DetailScreen.swift
//  To-Do
//
//  Created by Şükrü Şimşek on 13.11.2023.
//

import UIKit
import CoreData

protocol DetailScreenInterface: AnyObject {
    func configureVC()
    func configureSubject()
    func configureTag()
    func configureDesc()
    func configureButton()
    func checkTarget()
}



final class DetailScreen: UIViewController {
    private let viewModel = DetailViewModel()
    
    private var subjectText: UITextField!
    private var tagText: UITextField!
    private var descText: UITextField!
    private var button: UIButton!
    var targetSubject = ""
    var targetId: UUID?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.view = self
        viewModel.viewDidLoad()
        
    }
  
}

extension DetailScreen: DetailScreenInterface {
    func configureVC() {
        view.backgroundColor = .systemBackground
        
    }
    func configureSubject() {
        subjectText = UITextField(frame: .zero)
        subjectText.translatesAutoresizingMaskIntoConstraints = false
        subjectText.placeholder = "Konuyu Giriniz.."
        subjectText.font = .systemFont(ofSize: 15, weight: .semibold)
        subjectText.textColor = .secondaryLabel
        subjectText.textAlignment = .left
        subjectText.borderStyle = .roundedRect
        subjectText.layer.cornerRadius = 10
        subjectText.layer.borderColor = UIColor.opaqueSeparator.cgColor
        subjectText.layer.borderWidth = 1
        subjectText.layer.masksToBounds = true
        view.addSubview(subjectText)
        
        NSLayoutConstraint.activate([
            subjectText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            subjectText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            subjectText.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            
        ])
    }
    func configureTag() {
        tagText = UITextField(frame: .zero)
        tagText.translatesAutoresizingMaskIntoConstraints = false
        tagText.placeholder = "#tag"
        tagText.font = .systemFont(ofSize: 15, weight: .semibold)
        tagText.textColor = .secondaryLabel
        tagText.textAlignment = .left
        tagText.borderStyle = .roundedRect
        tagText.layer.cornerRadius = 10
        tagText.layer.borderColor = UIColor.opaqueSeparator.cgColor
        tagText.layer.borderWidth = 1
        tagText.layer.masksToBounds = true
        view.addSubview(tagText)
        
        NSLayoutConstraint.activate([
            tagText.topAnchor.constraint(equalTo: subjectText.bottomAnchor, constant: 20),
            tagText.leadingAnchor.constraint(equalTo: subjectText.leadingAnchor),
            tagText.trailingAnchor.constraint(equalTo: subjectText.trailingAnchor),
            
        ])
    }
    func configureDesc() {
        descText = UITextField(frame: .zero)
        descText.translatesAutoresizingMaskIntoConstraints = false
        descText.placeholder = "Açıklama Giriniz.."
        descText.font = .systemFont(ofSize: 15, weight: .semibold)
        descText.textColor = .secondaryLabel
        descText.textAlignment = .left
        descText.borderStyle = .roundedRect
        descText.layer.cornerRadius = 10
        descText.layer.borderColor = UIColor.opaqueSeparator.cgColor
        descText.layer.borderWidth = 1
        descText.layer.masksToBounds = true
        view.addSubview(descText)
        
        NSLayoutConstraint.activate([
            descText.topAnchor.constraint(equalTo: tagText.bottomAnchor,constant: 20),
            descText.leadingAnchor.constraint(equalTo: subjectText.leadingAnchor),
            descText.trailingAnchor.constraint(equalTo: subjectText.trailingAnchor),
            
        ])
    }
    func buttonTapped() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let saveData = NSEntityDescription.insertNewObject(forEntityName: "Todo", into: context)
        
        saveData.setValue(subjectText.text!, forKey: "subject")
        saveData.setValue(tagText.text!, forKey: "tag")
        saveData.setValue(descText.text!, forKey: "desc")
        saveData.setValue(UUID(), forKey: "id")
        
        
        
        do {
            try context.save()
            print("success")
        } catch  {
            print("error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
    }
    func configureButton() {
        button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Kaydet", for: .normal)
        button.backgroundColor = .systemTeal
        button.layer.cornerRadius = 10
        
        
        
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.buttonTapped()
            
        }), for: .touchUpInside)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: descText.bottomAnchor, constant: 20),
            button.leadingAnchor.constraint(equalTo: subjectText.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: subjectText.trailingAnchor)
        ])
        
        
    }
    func checkTarget() {
        if targetSubject != "" {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
            let idString = targetId?.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                for result in results as! [NSManagedObject] {
                    if let subject = result.value(forKey: "subject") as? String {
                        subjectText.text = subject
                    }
                    if let tag = result.value(forKey: "tag") as? String {
                        tagText.text = tag
                    }
                    if let desc = result.value(forKey: "desc") as? String {
                        descText.text = desc
                    }
                    
                        
                }
                
            } catch  {
                print("Error")
            }
        } else {
            
        }
    }
    
}
