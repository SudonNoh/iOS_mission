//
//  File.swift
//  AwesomeGifShareApp
//
//  Created by Sudon Noh on 2023/06/28.
//

import Foundation
import UIKit
import SnapKit
import Then


class CustomFlowCollectionViewFooter: UICollectionReusableView {
    
    lazy var lbl: UILabel = UILabel().then {
        $0.text = "풋터 라벨"
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lbl)
        
        lbl.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
