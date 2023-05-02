//
//  CodeCell.swift
//  UITableViewTutorial
//
//  Created by Sudon Noh on 2023/05/01.
//

import Foundation
import UIKit

class CodeCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "타이틀 라벨"
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    lazy var bodyLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "바디 라벨"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    /// 레이아웃 처리
    fileprivate func setupUI() {
        
        self.backgroundColor = .systemYellow
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.bodyLabel)
        
        // 타이틀 라벨 설정
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
        ])
        
        // 바디 라벨 설정
        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            bodyLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            bodyLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            bodyLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
        
    }
}


#if DEBUG
import SwiftUI

struct CodeCellPreView: PreviewProvider {
    static var previews: some View {
        CodeCell().toPreview()
            .previewLayout(.fixed(width: 200, height: 100))
    }
}
#endif
