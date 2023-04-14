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
        $0.addSubview(subTitleLbl)
        $0.addSubview(logoImg)
        $0.addSubview(stackView)
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
    
    lazy var logoImg: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "logo")
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var stackView: UIStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.addArrangedSubview(kakaoBtn)
        $0.addArrangedSubview(appleBtn)
        $0.addArrangedSubview(anotherBtn)
    }
    
    lazy var kakaoBtn: AlignedIconBtn = AlignedIconBtn(
        iconAlign: .leading,
        title: "카카오톡으로 3초만에 시작하기",
        font: UIFont.systemFont(ofSize: 13),
        bgColor: .systemYellow,
        tintColor: .black,
        icon: UIImage(systemName: "message.fill"),
        padding: UIEdgeInsets(top: 10, left: 60, bottom: 10, right: 30)
    )
    
    lazy var appleBtn: AlignedIconBtn = AlignedIconBtn(
        iconAlign: .leading,
        title: "Apple로 계속하기",
        font: UIFont.systemFont(ofSize: 13),
        bgColor: .black,
        tintColor: .white,
        icon: UIImage(systemName: "apple.logo")
    )
    
    lazy var anotherBtn: AlignedIconBtn = AlignedIconBtn(
        iconAlign: .leading,
        title: "다른 방법으로 시작하기",
        font: UIFont.systemFont(ofSize: 13),
        bgColor: .white,
        tintColor: .black
    ).then {
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
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
        
        subTitleLbl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLbl.snp.bottom).offset(10)
        }
        
        logoImg.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(subTitleLbl).offset(15)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(logoImg.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalTo(contentView.snp.bottom).offset(20)
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
