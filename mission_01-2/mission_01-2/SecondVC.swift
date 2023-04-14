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
        $0.backgroundColor = .yellow
    }
    
    lazy var searchImg: UIImageView = UIImageView().then {
        $0.image = UIImage(systemName: "magnifyingglass.circle")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavi(title: "검색")
        self.setUI()
        
        self.view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(200)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(100)
        }
        
        searchImg.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setUI() {
        self.view.backgroundColor = .white
        

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
