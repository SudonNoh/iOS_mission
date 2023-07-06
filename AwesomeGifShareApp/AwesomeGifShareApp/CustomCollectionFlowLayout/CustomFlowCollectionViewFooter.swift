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
    
    lazy var footerIndicator: UIActivityIndicatorView = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.color = UIColor.systemGray
        $0.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        $0.center = self.center
        $0.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        $0.startAnimating()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(self.footerIndicator)
        
        footerIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
