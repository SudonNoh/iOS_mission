//
//  SecondVC.swift
//  mission_01-2
//
//  Created by Sudon Noh on 2023/04/14.
//

import Foundation
import UIKit
import SnapKit
import Then


class SecondVC: UIViewController {
    
    lazy var searchBar: UIView = UIView().then {
        $0.addSubview(searchImg)
        $0.addSubview(searchTxtField)
        $0.addSubview(searchUnderBar)
    }
    
    lazy var searchImg: UIImageView = UIImageView().then {
        $0.image = UIImage(systemName: "magnifyingglass")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .black
    }
    
    lazy var searchTxtField: UITextField = UITextField().then {
        $0.placeholder = "어떤 것을 찾고 있나요?"
        $0.font = UIFont.systemFont(ofSize: 15)
    }
    
    lazy var searchUnderBar: UIView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    lazy var containerView: UIView = UIView().then {
        $0.addSubview(imgStackView)
        $0.addSubview(lbl)
    }
    
    lazy var imgStackView: UIStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.spacing = 10
        $0.addArrangedSubview(img1)
        $0.addArrangedSubview(img2)
        $0.addArrangedSubview(img3)
    }
    
    lazy var img1: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "img1")
    }
    
    lazy var img2: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "img2")
    }

    lazy var img3: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "img3")
    }
    
    lazy var lbl: UILabel = UILabel().then {
        $0.text = "심리상담사, 심리워크샵, 힐링상품을 검색해 보세요."
        $0.textColor = .lightGray
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavi(title: "검색")
        self.setUI()
    }
    
    fileprivate func setUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(searchBar)
        self.view.addSubview(containerView)
        
        
        let guide = self.view.safeAreaLayoutGuide
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(guide.snp.top).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        searchImg.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
        
        searchTxtField.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(searchImg.snp.trailing).offset(5)
        }
        
        searchUnderBar.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(50)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(200)
        }
        
        imgStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
        
        img1.snp.makeConstraints {
            $0.height.width.equalTo(70)
        }
        
        lbl.snp.makeConstraints {
            $0.top.equalTo(imgStackView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}


#if DEBUG
import SwiftUI

struct SecondVCPreView: PreviewProvider {
    static var previews: some View {
        SecondVC().toPreview()
    }
}
#endif
