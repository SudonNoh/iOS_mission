//
//  ViewController.swift
//  CustomLoadingBtnTutorial
//
//  Created by Sudon Noh on 2023/04/06.
//

import UIKit
import SnapKit
import Then

class ViewController: UIViewController {
    
    lazy var myScrollView : UIScrollView = UIScrollView().then {
        $0.isUserInteractionEnabled = true
        $0.alwaysBounceVertical = true
        $0.alwaysBounceHorizontal = false
        $0.addSubview(containerView)
    }
    
    lazy var containerView : UIView = UIView().then {
        $0.backgroundColor = .systemYellow
        $0.addSubview(btnStackView)
    }
    
    lazy var btnStackView : UIStackView = UIStackView().then {
        // 아이템 간 간격
        $0.spacing = 10
        $0.alignment = .fill
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .systemCyan
        
        setupUI()
    }
    
    /// UI설정
    fileprivate func setupUI() {
        print(#fileID, #function, #line, "- ")
        self.view.addSubview(myScrollView)
        
        // ScrollView
        myScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // ContainerView
        containerView.snp.makeConstraints {
            $0.width.equalTo(myScrollView.frameLayoutGuide.snp.width)
            $0.edges.equalTo(myScrollView.contentLayoutGuide.snp.edges)
        }
        
        let dummyBtns = Array(0...20).map { index in
//            UIButton(configuration: .filled()).then {
//                $0.setTitle("Button \(index)", for: .normal)
//            }
            AlignedIconButton(
                title: "버튼 \(index)",
                bgColor: .systemCyan,
                tintColor: .black,
                cornerRadius: 10,
                icon: UIImage(systemName: "pencil.circle")
            )
        }
        
        // BtnStackView
        btnStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
        dummyBtns.forEach {
            btnStackView.addArrangedSubview($0)
        }
        
    }
}

#if DEBUG
import SwiftUI

struct ViewControllerPreView: PreviewProvider {
    static var previews: some View {
        ViewController().toPreview().ignoresSafeArea()
    }
}
#endif
