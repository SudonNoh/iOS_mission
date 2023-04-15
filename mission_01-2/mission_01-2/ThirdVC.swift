//
//  ThirdVC.swift
//  mission_01-2
//
//  Created by Sudon Noh on 2023/04/15.
//

import Foundation
import UIKit
import SnapKit
import Then


class ThirdVC: UIViewController {
    
    // 화면 전체 스크롤
    lazy var scrollView: UIScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.addSubview(containerView)
    }
    
    // 화면 전체 컨테이너
    lazy var containerView: UIView = UIView().then {
        $0.addSubview(topViewContainer)
        $0.addSubview(secondViewContainer)
        $0.addSubview(thirdViewContainer)
        $0.addSubview(forthViewContainer)
    }
    
    // 상단 컨테이너
    lazy var topViewContainer: UIView = UIView().then {
        $0.addSubview(topViewBackground)
        $0.addSubview(topViewImg)
    }
    
    // 상단 배경
    lazy var topViewBackground: UIView = UIView().then {
        $0.backgroundColor = .systemMint
    }
    
    // 상단 캐릭터
    lazy var topViewImg: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "logo2")
        $0.contentMode = .scaleAspectFit
    }
    
    // 두번째 컨테이너
    lazy var secondViewContainer: UIView = UIView().then {
        
        let secondViewTitle: UILabel = UILabel().then {
            $0.text = "에너지가 뭐에요?"
            $0.font = UIFont.boldSystemFont(ofSize: 17)
        }
        
        $0.addSubview(secondViewTitle)
        
        secondViewTitle.snp.makeConstraints{
            $0.top.leading.equalToSuperview()
        }
    }
    
    // 세번째 컨테이너
    lazy var thirdViewContainer: UIView = UIView().then {
        $0.backgroundColor = .brown
    }
    
    lazy var forthViewContainer: UIView = UIView().then {
        $0.addSubview(forthViewTitle)
        $0.backgroundColor = .yellow
    }
    lazy var forthViewTitle: UILabel = UILabel().then {
        $0.text = "어떻게 모으나요?"
        $0.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavi(title: "에너지 이용안내")
        
        self.setUp()
    }
    
    fileprivate func setUp() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
        }
        
        containerView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide.snp.edges)
            $0.width.equalTo(scrollView.frameLayoutGuide.snp.width)
        }
        
        // Top
        topViewContainer.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(310)
        }
        
        topViewBackground.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(topViewContainer.snp.centerY)
        }
        
        topViewImg.snp.makeConstraints {
            $0.top.equalTo(topViewBackground.snp.centerY)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        // Second
        secondViewContainer.snp.makeConstraints {
            $0.top.equalTo(topViewContainer.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        
        // Third
        thirdViewContainer.snp.makeConstraints {
            $0.top.equalTo(secondViewContainer.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(100)
        }
        
        // Forth
        forthViewContainer.snp.makeConstraints {
            $0.top.equalTo(thirdViewContainer.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        forthViewTitle.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
    }
}



#if DEBUG
import SwiftUI

struct ThirdVCPreView: PreviewProvider {
    static var previews: some View {
        ThirdVC().toPreview()
    }
}
#endif
