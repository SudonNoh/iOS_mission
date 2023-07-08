//
//  CollectionViewCell.swift
//  CollectionView
//
//  Created by Sudon Noh on 2023/07/06.
//

import Foundation
import UIKit
import SnapKit
import Then

class HorizontalCollectionViewCell: UICollectionViewCell {
    
    lazy var img: UIImageView = UIImageView().then {
        $0.image = UIImage(systemName: "photo")
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .yellow
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    fileprivate func setupUI() {
        addSubview(img)
        backgroundColor = .white
        
        img.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(300)
        }
    }
}
