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
    
    lazy var contentBoxView: UIView = UIView().then {
        $0.addSubview(titleLabel)
        $0.addSubview(dateStackView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
        
        dateStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.bottom.equalTo(createdDateLabel.snp.bottom)
        }
    }
    
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
    
    lazy var bottomMarginView: UIView = UIView().then {
        $0.backgroundColor = .bgColor
    }
    lazy var topMarginView: UIView = UIView().then {
        $0.backgroundColor = .bgColor
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
        
        self.contentView.addSubview(contentBoxView)
        self.contentView.addSubview(topMarginView)
        self.contentView.addSubview(bottomMarginView)
        
        topMarginView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(5)
        }
        
        contentBoxView.snp.makeConstraints {
            $0.top.equalTo(topMarginView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(dateStackView.snp.bottom).offset(10)
        }
        
        bottomMarginView.snp.makeConstraints {
            $0.top.equalTo(contentBoxView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(5)
        }
    }
    
    func updateUI(_ data: Todo) {
        guard let title = data.title,
              let updateDate = data.updatedAt,
              let createDate = data.createdAt,
              let isDone = data.isDone else {return}
        
        let updateAt = dateFormatter(frontString: "update:", date: updateDate)
        let createAt = dateFormatter(frontString: "create:", date: createDate)
        
        self.titleLabel.text = title
        self.updatedDateLabel.text = updateAt
        self.createdDateLabel.text = createAt
        
        let labelColor: UIColor = isDone ? .lightGray : .textColor ?? .white
        
        self.titleLabel.textColor = labelColor
        self.updatedDateLabel.textColor = labelColor
        self.createdDateLabel.textColor = labelColor
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
