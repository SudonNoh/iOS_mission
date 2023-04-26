//
//  UIStackView+Ext.swift
//  mission_01-2
//
//  Created by Sudon Noh on 2023/04/24.
//

import Foundation
import UIKit
import SnapKit
import Then


class CustomStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(
        img: String,
        lblTxt: String
    ) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .vertical
        self.distribution = .fill
        self.spacing = 10
        
        let selectedImage : UIImageView = UIImageView().then {
            $0.image = UIImage(named:img)
            $0.contentMode = .scaleAspectFit
        }
        
        let lbl: UILabel = UILabel().then {
            $0.text = lblTxt
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.textAlignment = .center
        }
        
        self.addArrangedSubview(selectedImage)
        self.addArrangedSubview(lbl)
        
        selectedImage.snp.makeConstraints {
            $0.width.equalTo(75)
            $0.height.equalTo(75)
        }
    }
}
