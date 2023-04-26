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
        $0.addSubview(firstViewTitle)
        $0.addSubview(firstViewContainer)
        $0.addSubview(secondViewTitle)
        $0.addSubview(secondViewContainer1)
        $0.addSubview(secondViewContainer2)
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
    
    // 첫 번째 타이틀
    lazy var firstViewTitle: UILabel = UILabel().then {
        $0.text = "에너지가 뭐에요?"
        $0.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    // 첫 번째 타이틀 하위 컨테이너
    lazy var firstViewContainer: UIView = UIView().then {
        
        let dot1 = dot(txt: "·")
        let dot2 = dot(txt: "·")
        let content1 = contentLbl(txt: "트로스트에서 마음을 관리할 때마다 쌓이는 현금성 포인트에요.")
        let content2 = contentLbl(txt: "매일 가볍게 관리하며 모은 에너지로, 유료 서비스도 저렴하게 이용해요!")
        
        $0.addSubview(dot1)
        $0.addSubview(content1)
        $0.addSubview(dot2)
        $0.addSubview(content2)
        
        dot1.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        content1.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(dot1.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
        }
        
        dot2.snp.makeConstraints {
            $0.top.equalTo(content1.snp.bottom).offset(5)
            $0.leading.equalToSuperview()
        }
        
        content2.snp.makeConstraints {
            $0.top.equalTo(dot2.snp.top)
            $0.leading.equalTo(dot2.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
        }
    }
    
    // 두 번째 타이틀
    lazy var secondViewTitle: UILabel = UILabel().then {
        $0.text = "어떻게 모으나요?"
        $0.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    // 두 번째 타이틀 하위 컨테이너-1
    lazy var secondViewContainer1: UIView = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.9528092742, green: 0.9528092742, blue: 0.9528092742, alpha: 1)
        
        let horiStackView: UIStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 40
        }
        
        let vertiStackView1: CustomStackView = CustomStackView(img: "sound", lblTxt: "사운드테라피")
        let vertiStackView2: CustomStackView = CustomStackView(img: "timer", lblTxt: "루틴")
        
        horiStackView.addArrangedSubview(vertiStackView1)
        horiStackView.addArrangedSubview(vertiStackView2)
        
        $0.addSubview(horiStackView)
        
        horiStackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    // 두 번째 타이틀 하위 컨테이너-2
    lazy var secondViewContainer2: UIView = UIView().then {
        let dot1 = dot(txt: "·")
        let dot2 = dot(txt: "·")
        let content1 = contentLbl(txt: "사운드테라피를 듣거나 루틴 완료 시 각각 하루 3번까지 에너지를 받을 수 있어요.")
        let content2 = contentLbl(txt: "기본 에너지 5개씩 받을 수 있고, 하루 한 번 랜덤 보너스도 있어요.")
        
        $0.addSubview(dot1)
        $0.addSubview(content1)
        $0.addSubview(dot2)
        $0.addSubview(content2)
        
        dot1.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        content1.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(dot1.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
        }
        
        dot2.snp.makeConstraints {
            $0.top.equalTo(content1.snp.bottom).offset(5)
            $0.leading.equalToSuperview()
        }
        
        content2.snp.makeConstraints {
            $0.top.equalTo(dot2.snp.top)
            $0.leading.equalTo(dot2.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
        }
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
            $0.bottom.equalTo(secondViewContainer2.snp.bottom).offset(20)
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
        
        firstViewTitle.snp.makeConstraints {
            $0.top.equalTo(topViewContainer.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(16)
        }
        
        firstViewContainer.snp.makeConstraints {
            $0.top.equalTo(firstViewTitle.snp.bottom).offset(7)
            $0.leading.equalTo(firstViewTitle.snp.leading)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(100)
        }
        
        secondViewTitle.snp.makeConstraints {
            $0.top.equalTo(firstViewContainer.snp.bottom).offset(10)
            $0.leading.equalTo(firstViewTitle.snp.leading)
        }
        
        secondViewContainer1.snp.makeConstraints {
            $0.top.equalTo(secondViewTitle.snp.bottom).offset(7)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(120)
        }
        
        secondViewContainer2.snp.makeConstraints {
            $0.top.equalTo(secondViewContainer1.snp.bottom).offset(7)
            $0.leading.equalTo(secondViewTitle.snp.leading)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(100)
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
