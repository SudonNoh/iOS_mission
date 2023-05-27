//
//  Cell.swift
//  WhatTodoApp
//
//  Created by Sudon Noh on 2023/05/18.
//

import Foundation
import UIKit
import SnapKit
import Then

class TodoCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = UILabel().then {
        $0.text = "해야 할 일들을 정리하는 곳 입니다."
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .textColor
        $0.lineBreakMode = .byCharWrapping
    }
    
    lazy var dateStackView: UIStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 5
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.addArrangedSubview(updatedDateLabel)
        $0.addArrangedSubview(createdDateLabel)
    }
    
    lazy var updatedDateLabel: UILabel = UILabel().then {
        $0.text = "Update: 9999-99-99 24시 59분"
        $0.numberOfLines = 1
        $0.font = UIFont.systemFont(ofSize: 10)
        $0.textColor = .textColor
        $0.textAlignment = .center
    }
    
    lazy var createdDateLabel: UILabel = UILabel().then {
        $0.text = "Create: 9999-99-99 24시 59분"
        $0.numberOfLines = 1
        $0.font = UIFont.systemFont(ofSize: 10)
        $0.textColor = .textColor
        $0.textAlignment = .center
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func setupUI() {
        self.backgroundColor = .bgColor
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(dateStackView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.horizontalEdges.equalToSuperview().inset(12)
        }
        
        dateStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(5)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        dateStackView.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    func updateUI(_ data: Todo) {
        guard let title = data.title,
              let updateDate = data.updatedAt,
              let createDate = data.createdAt else {return}
        
        let updateAt = dateFormatter(frontString: "update:", date: updateDate)
        let createAt = dateFormatter(frontString: "create:", date: createDate)
        
        self.titleLabel.text = title
        self.updatedDateLabel.text = updateAt
        self.createdDateLabel.text = createAt
    }
    
    /// Change Date Format String To String with Custom String
    /// - Parameters:
    ///   - frontString: It will be front of return value
    ///   - date: date String
    /// - Returns: frontString + date : "frontString + yyyy-MM-dd HH시 mm분"
    fileprivate func dateFormatter(frontString: String, date: String) -> String {
        
        let dateFormat1st = "yyyy-MM-dd'T'HH:mm:ss.ssssssZ"
        let dateFormat2nd = "yyyy-MM-dd HH시 mm분"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat1st
        let dateFromString = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = dateFormat2nd
        guard let confirmDate = dateFromString else { return "" }
        let stringDate = dateFormatter.string(from: confirmDate)
        
        return frontString + " " + stringDate
    }
}


#if DEBUG
import SwiftUI

struct TodoCellPreView: PreviewProvider {
    static var previews: some View {
        TodoCell()
            .toPreview()
            .previewLayout(.sizeThatFits)
            .frame(width: 350, height: 120)
    }
}
#endif
