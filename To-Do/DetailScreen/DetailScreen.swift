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
}



class DetailScreen: UIViewController {
    private let viewModel = DetailViewModel()
    
    private var subject: UITextField!
    private var tag: UITextField!
    private var desc: UITextField!
    private var button: UIButton!
    var targetName = ""
    var targetId: UUID?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.view = self
        viewModel.viewDidLoad()
        
    }
  
}

extension DetailScreen: DetailScreenInterface {
    func configureVC() {
        view.backgroundColor = .cyan
        
    }
    func configureSubject() {
        subject = UITextField(frame: .zero)
        subject.translatesAutoresizingMaskIntoConstraints = false
        subject.placeholder = "Konuyu Giriniz.."
        subject.font = .systemFont(ofSize: 12, weight: .semibold)
        subject.textColor = .secondaryLabel
        subject.textAlignment = .left
        subject.borderStyle = .bezel
        view.addSubview(subject)
        
        NSLayoutConstraint.activate([
            subject.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            subject.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            subject.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            
        ])
    }
    func configureTag() {
        tag = UITextField(frame: .zero)
        tag.translatesAutoresizingMaskIntoConstraints = false
        tag.placeholder = "#tag"
        tag.font = .systemFont(ofSize: 12, weight: .semibold)
        tag.textColor = .secondaryLabel
        tag.textAlignment = .left
        tag.borderStyle = .bezel
        view.addSubview(tag)
        
        NSLayoutConstraint.activate([
            tag.topAnchor.constraint(equalTo: subject.bottomAnchor, constant: 20),
            tag.leadingAnchor.constraint(equalTo: subject.leadingAnchor),
            tag.trailingAnchor.constraint(equalTo: subject.trailingAnchor),
            
        ])
    }
    func configureDesc() {
        desc = UITextField(frame: .zero)
        desc.translatesAutoresizingMaskIntoConstraints = false
        desc.placeholder = "Açıklama Giriniz.."
        desc.font = .systemFont(ofSize: 12, weight: .semibold)
        desc.textColor = .secondaryLabel
        desc.textAlignment = .left
        desc.borderStyle = .bezel
        view.addSubview(desc)
        
        NSLayoutConstraint.activate([
            desc.topAnchor.constraint(equalTo: tag.bottomAnchor,constant: 20),
            desc.leadingAnchor.constraint(equalTo: subject.leadingAnchor),
            desc.trailingAnchor.constraint(equalTo: subject.trailingAnchor),
            
        ])
    }
    func buttonTapped() {
        print("deneme")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let saveData = NSEntityDescription.insertNewObject(forEntityName: "Todo", into: context)
        
        saveData.setValue(subject.text!, forKey: "subject")
        saveData.setValue(tag.text!, forKey: "tag")
        saveData.setValue(desc.text!, forKey: "desc")
        saveData.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
            print("success")
        } catch  {
            print("error")
        }
        
    }
    func configureButton() {
        button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Kaydet", for: .normal)
        button.backgroundColor = .systemTeal
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.buttonTapped()
            
        }), for: .touchUpInside)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: desc.bottomAnchor, constant: 20),
            button.leadingAnchor.constraint(equalTo: subject.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: subject.trailingAnchor)
        ])
        
        
    }
    
}
