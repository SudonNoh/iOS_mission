//
//  CustomFlowCollectionViewHeader.swift
//  AwesomeGifShareApp
//
//  Created by Sudon Noh on 2023/06/28.
//

import Foundation
import UIKit
import SnapKit
import Then


class CustomFlowCollectionViewHeader: UICollectionReusableView {
    
    lazy var lbl: UILabel = UILabel().then {
        $0.text = "선택한 움짤 개수: 0"
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.textAlignment = .center
        $0.textColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lbl)
        self.backgroundColor = .darkGray
        
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
