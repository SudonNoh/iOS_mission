//
//  ViewController.swift
//  mission_01-1
//
//  Created by Sudon Noh on 2023/03/30.
//

import UIKit

class FirstVC: UIViewController {
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Trost."
        lbl.font = UIFont.boldSystemFont(ofSize: 50)
        lbl.textAlignment = .center
        return lbl
    }()
    
    let subTitleLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "마음도 관리가 필요하니까."
        lbl.textAlignment = .center
        return lbl
    }()
    
    let logoImg: UIImageView = {
       let view = UIImageView()
        let img = UIImage(named: "LogoImg")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = img
        view.contentMode = .center
        return view
    }()
    
    lazy var startAnotherLoginBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("다른 방법으로 시작하기", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
        return btn
    }()
    
    let btnsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        // stackView 겉에 공백 넣는 방법
        // stackView.isLayoutMarginsRelativeArrangement = true
        // stackView.layoutMargins = UIEdgeInsets(top:10, left:10, bottom: 10, right: 10)
        
        var kakaoBtnWithImg = UIButton.Configuration.filled()
        kakaoBtnWithImg.title = "카카오톡으로 3초만에 시작하기"
        kakaoBtnWithImg.baseForegroundColor = .black
        kakaoBtnWithImg.background.backgroundColor = .systemYellow
        kakaoBtnWithImg.image = UIImage(systemName: "message.fill")
        kakaoBtnWithImg.imagePlacement = .leading
        kakaoBtnWithImg.imagePadding = 10

        var appleBtnWithImg = UIButton.Configuration.filled()
        appleBtnWithImg.title = "Apple로 계속하기"
        appleBtnWithImg.baseForegroundColor = .white
        appleBtnWithImg.background.backgroundColor = .black
        appleBtnWithImg.image = UIImage(systemName: "apple.logo")
        appleBtnWithImg.imagePlacement = .leading
        appleBtnWithImg.imagePadding = 10

        let kakaoLoginBtn = UIButton(configuration: kakaoBtnWithImg)
        let appleLoginBtn = UIButton(configuration: appleBtnWithImg)
        
        stackView.addArrangedSubview(kakaoLoginBtn)
        stackView.addArrangedSubview(appleLoginBtn)
        
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(titleLbl)
        containerView.addSubview(subTitleLbl)
        containerView.addSubview(logoImg)
        containerView.addSubview(btnsStackView)
        
        let guide = self.view.safeAreaLayoutGuide
        
        // ScrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: guide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            
            scrollView.contentLayoutGuide.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: containerView.topAnchor),
            
            scrollView.frameLayoutGuide.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1)
        ])

        // TitleLbl & SubTitleLbl
        NSLayoutConstraint.activate([
            titleLbl.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 50),
            titleLbl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLbl.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 20),
            subTitleLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 10),
            subTitleLbl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            subTitleLbl.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor , constant: 10),
        ])
        
        // LogoImage
        NSLayoutConstraint.activate([
            logoImg.topAnchor.constraint(equalTo: subTitleLbl.bottomAnchor, constant: 15),
            logoImg.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        btnsStackView.addArrangedSubview(startAnotherLoginBtn)

        // Btn StackView
        NSLayoutConstraint.activate([
            btnsStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            btnsStackView.topAnchor.constraint(equalTo: logoImg.bottomAnchor, constant: 20),
            btnsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            
            btnsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            
            startAnotherLoginBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 버튼 3 누르면 동작하는 버튼
        startAnotherLoginBtn.addTarget(self, action: #selector(goToNext(_:)), for: .touchUpInside)
    }
    
    @objc func goToNext(_ sender: UIButton) {
        print(#fileID, #function, #line, "- 버튼이 눌렸습니다.")
    }
}

#if DEBUG
import SwiftUI

struct FirstVCPreView: PreviewProvider {
    static var previews: some View {
        FirstVC().toPreview()
    }
}
#endif


