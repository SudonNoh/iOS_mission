//
//  ViewController.swift
//  mission_01-2
//
//  Created by Sudon Noh on 2023/04/12.
//
import Foundation
import UIKit
import SnapKit
import Then


class FirstVC: UIViewController {
    
    lazy var scrollView: UIScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.addSubview(contentView)
    }
    
    lazy var contentView: UIView = UIView().then {
        $0.addSubview(titleLbl)
    }
    
    lazy var titleLbl: UILabel = UILabel().then {
        $0.text = "Trost."
        $0.font = UIFont.boldSystemFont(ofSize: 50)
        $0.textAlignment = .center
    }
    
    lazy var subTitleLbl: UILabel = UILabel().then {
        $0.text = "마음도 관리가 필요하니까."
        $0.textAlignment = .center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide.snp.edges)
            $0.width.equalTo(scrollView.frameLayoutGuide.snp.width)
        }
        
        titleLbl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(50)
        }
        
        
    }
}

#if DEBUG
import SwiftUI

struct FirstVCPreView: PreviewProvider {
    static var previews: some View {
        FirstVC().toPreview().ignoresSafeArea()
    }
}
#endif
