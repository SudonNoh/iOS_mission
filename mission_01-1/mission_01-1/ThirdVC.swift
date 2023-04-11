//
//  ThirdVC.swift
//  mission_01-1
//
//  Created by Sudon Noh on 2023/04/11.
//

import Foundation
import UIKit


class ThirdVC: UIViewController {
    
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
    
    let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.7370074987, green: 0.9994406104, blue: 0.8088781238, alpha: 1)
        return view
    }()
    
    let logoImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(named: "img4")
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    let firstView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        let title: UILabel = {
            let lbl = UILabel()
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.text = "에너지가 뭐에요?"
            lbl.font = UIFont.boldSystemFont(ofSize: 17)
            return lbl
        }()
        let dot1: dot = dot(txt:"·")
        let dot2: dot = dot(txt:"·")
        let content1: contentLbl = contentLbl(txt: "트로스트에서 마음을 관리할 때마다 쌓이는 현금성 포인트에요.")
        let content2: contentLbl = contentLbl(txt: "매일 가볍게 관리하며 모은 에너지로, 유료 서비스도 저렴하게 이용해요!")

        view.addSubview(title)
        view.addSubview(dot1)
        view.addSubview(content1)
        view.addSubview(dot2)
        view.addSubview(content2)

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: view.topAnchor),
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            title.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor),
            
            dot1.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 7),
            dot1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            
            content1.topAnchor.constraint(equalTo: dot1.topAnchor),
            content1.leadingAnchor.constraint(equalTo: dot1.trailingAnchor, constant: 8),
            content1.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            dot2.topAnchor.constraint(equalTo: dot1.bottomAnchor, constant: 30),
            dot2.leadingAnchor.constraint(equalTo: dot1.leadingAnchor),
            
            content2.topAnchor.constraint(equalTo: dot2.topAnchor),
            content2.leadingAnchor.constraint(equalTo: dot2.trailingAnchor, constant: 8),
            content2.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        dot1.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        content1.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
        dot2.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        content2.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
        
        return view
    }()
    


    let secondView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let title: UILabel = {
            let lbl = UILabel()
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.text = "어떻게 모으나요?"
            lbl.font = UIFont.boldSystemFont(ofSize: 17)
            return lbl
        }()
        
        let containerView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = #colorLiteral(red: 0.9528092742, green: 0.9528092742, blue: 0.9528092742, alpha: 1)
            return view
        }()
        
        let horiStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 40
            return stackView
        }()
        
        let vertiStackView1: UIStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.distribution = .fill
            stackView.spacing = 10
            
            let img: UIImageView = {
                let img = UIImageView()
                img.translatesAutoresizingMaskIntoConstraints = false
                img.image = UIImage(named: "sound")
                img.contentMode = .scaleAspectFill
                return img
            }()
            let lbl: UILabel = {
                let lbl = UILabel()
                lbl.text = "사운드테라피"
                lbl.font = UIFont.systemFont(ofSize: 14)
                lbl.textAlignment = .center
                return lbl
            }()
            
            stackView.addArrangedSubview(img)
            stackView.addArrangedSubview(lbl)
            
            NSLayoutConstraint.activate([
                img.heightAnchor.constraint(equalToConstant: 75),
                img.widthAnchor.constraint(equalToConstant: 75)
            ])
            
            return stackView
        }()
        
        let vertiStackView2: UIStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.distribution = .fill
            stackView.spacing = 10
            
            let img: UIImageView = {
                let img = UIImageView()
                img.translatesAutoresizingMaskIntoConstraints = false
                img.image = UIImage(named: "timer")
                img.contentMode = .scaleAspectFill
                return img
            }()
            let lbl: UILabel = {
                let lbl = UILabel()
                lbl.text = "루틴"
                lbl.font = UIFont.systemFont(ofSize: 14)
                lbl.textAlignment = .center
                return lbl
            }()
            
            stackView.addArrangedSubview(img)
            stackView.addArrangedSubview(lbl)
            
            NSLayoutConstraint.activate([
                img.heightAnchor.constraint(equalToConstant: 75),
                img.widthAnchor.constraint(equalToConstant: 75)
            ])
            
            return stackView
        }()
        
        let dot1: dot = dot(txt:"·")
        let dot2: dot = dot(txt:"·")
        let content1: contentLbl = contentLbl(txt: "사운드테라피를 듣거나 루틴 완료 시 각각 하루 3번까지 에너지를 받을 수 있어요.")
        let content2: contentLbl = contentLbl(txt: "기본 에너지 5개씩 받을 수 있고, 하루 한 번 랜덤 보너스도 있어요.")

        view.addSubview(title)
        view.addSubview(containerView)
        containerView.addSubview(horiStackView)
        horiStackView.addArrangedSubview(vertiStackView1)
        horiStackView.addArrangedSubview(vertiStackView2)
        view.addSubview(dot1)
        view.addSubview(content1)
        view.addSubview(dot2)
        view.addSubview(content2)

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: view.topAnchor),
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            title.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor),
            
            containerView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 15),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 120),
            
            horiStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            horiStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            dot1.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 14),
            dot1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            
            content1.topAnchor.constraint(equalTo: dot1.topAnchor),
            content1.leadingAnchor.constraint(equalTo: dot1.trailingAnchor, constant: 8),
            content1.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            dot2.topAnchor.constraint(equalTo: dot1.bottomAnchor, constant: 30),
            dot2.leadingAnchor.constraint(equalTo: dot1.leadingAnchor),
            
            content2.topAnchor.constraint(equalTo: dot2.topAnchor),
            content2.leadingAnchor.constraint(equalTo: dot2.trailingAnchor, constant: 8),
            content2.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        dot1.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        content1.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
        dot2.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        content2.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.addNavi(title: "에너지 이용안내")
        
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(containerView)
        self.containerView.addSubview(backgroundView)
        self.containerView.addSubview(logoImgView)
        self.containerView.addSubview(firstView)
        self.containerView.addSubview(secondView)
        
        let guide = self.view.safeAreaLayoutGuide
        
        // ScrollView Setting
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: guide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            
            scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: containerView.topAnchor),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            scrollView.contentLayoutGuide.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            scrollView.frameLayoutGuide.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1),
        ])
        
        // logo Part
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 140),
            
            logoImgView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 40),
            logoImgView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            logoImgView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            logoImgView.heightAnchor.constraint(equalToConstant: 170)
        ])
        
        // first TextBox
        NSLayoutConstraint.activate([
            firstView.topAnchor.constraint(equalTo: logoImgView.bottomAnchor, constant: 15),
            firstView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            firstView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            firstView.heightAnchor.constraint(equalToConstant: 130),
        ])
        // second TextBox
        NSLayoutConstraint.activate([
            secondView.topAnchor.constraint(equalTo: firstView.bottomAnchor, constant: 15),
            secondView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            secondView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            secondView.heightAnchor.constraint(equalToConstant: 320),
            secondView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        
        ])
        
    }
}

#if DEBUG
import SwiftUI

struct ThirdVCPreView: PreviewProvider {
    static var previews: some View {
        ThirdVC().toPreview().ignoresSafeArea()
    }
}
#endif
