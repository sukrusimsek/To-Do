//
//  ToDoCell.swift
//  To-Do
//
//  Created by Şükrü Şimşek on 14.11.2023.
//

import UIKit

final class ToDoCell: UITableViewCell {
    static let resueId = "ToDoCell"
    var tagLabel = UILabel()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureCell() {
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagLabel = UILabel(frame: CGRect(x: contentView.frame.width - 10, y: 7, width: contentView.frame.width / 4, height: contentView.frame.height / 1.5))
        tagLabel.textColor = UIColor.black
        tagLabel.textAlignment = .center
        //tagLabel.backgroundColor = UIColor.green
        tagLabel.layer.cornerRadius = 10
        tagLabel.layer.masksToBounds = true
        addSubview(tagLabel)
        
        
        
    }

}
