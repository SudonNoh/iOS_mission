//
//  ForthVC.swift
//  mission_01-1
//
//  Created by Sudon Noh on 2023/04/12.
//

import Foundation
import UIKit


class ForthVC: UIViewController {
    
    let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "오전, 오후 풀타임 빡코딩 스터디\n빡코딩 하는 사람만"
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.numberOfLines = 2
        return lbl
    }()
    
    let profileImg1: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "profile1")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    let contentLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "하루 10시간 이상 빡코딩 하실분 오세요~\n취준생, 현직 개발자, 이직을 위한 빡코딩, 취미 개발 등\n모두 환영입니다!"
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.numberOfLines = 3
        return lbl
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor(red: 0.37, green: 0.39, blue: 0.40, alpha: 1.00).cgColor
        view.layer.shadowOffset = CGSize()
        view.layer.shadowOpacity = 0.19
        view.layer.shadowRadius = 15.0
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 12.0
        
        return view
    }()
    
    let roomInfoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImg2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "profile2")
        img.contentMode = .scaleAspectFit
        
        let img2 = UIImageView()
        img2.translatesAutoresizingMaskIntoConstraints = false
        img2.image = UIImage(named: "star")
        img2.contentMode = .scaleAspectFit
        
        view.addSubview(img)
        view.addSubview(img2)
        
        NSLayoutConstraint.activate([
            img.topAnchor.constraint(equalTo: view.topAnchor),
            img.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            img.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            img.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            img2.bottomAnchor.constraint(equalTo: img.bottomAnchor),
            img2.trailingAnchor.constraint(equalTo: img.trailingAnchor),
            img2.widthAnchor.constraint(equalToConstant: 24),
            img2.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        return view
    }()
    
    let roomTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "풀타임 빡코 모임방"
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        return lbl
    }()
    
    let roomSubTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "24시간 빡코딩 할 분들 모집합니다!"
        lbl.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        return lbl
    }()
    
    let activeMember: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let lbl1 = UILabel()
        lbl1.translatesAutoresizingMaskIntoConstraints = false
        lbl1.text = "활동 중 멤버 249명"
        lbl1.textColor = .systemBlue
        lbl1.font = UIFont.systemFont(ofSize: 12)
        
        let lbl2 = UILabel()
        lbl2.translatesAutoresizingMaskIntoConstraints = false
        lbl2.text = "/ 정원 250명"
        lbl2.font = UIFont.systemFont(ofSize: 12)
        
        view.addSubview(lbl1)
        view.addSubview(lbl2)
        
        NSLayoutConstraint.activate([
            lbl1.topAnchor.constraint(equalTo: view.topAnchor),
            lbl1.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            lbl2.topAnchor.constraint(equalTo: view.topAnchor),
            lbl2.leadingAnchor.constraint(equalTo: lbl1.trailingAnchor, constant: 4),
            lbl2.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor),
        ])
        
        return view
    }()
    
    let msgView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        view.layer.cornerRadius = 5
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "anonymous")
        img.contentMode = .scaleAspectFit
        
        let lbl1 = UILabel()
        lbl1.translatesAutoresizingMaskIntoConstraints = false
        lbl1.text = "빡코딩님의 메세지가 있습니다."
        lbl1.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lbl1.font = UIFont.systemFont(ofSize: 12)
        
        let lbl2 = UILabel()
        lbl2.translatesAutoresizingMaskIntoConstraints = false
        lbl2.text = "22시간 전"
        lbl2.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lbl2.font = UIFont.systemFont(ofSize: 12)
        
        view.addSubview(img)
        view.addSubview(lbl1)
        view.addSubview(lbl2)
        
        NSLayoutConstraint.activate([
            img.widthAnchor.constraint(equalToConstant: 26),
            img.heightAnchor.constraint(equalToConstant: 26),
            img.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            img.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            lbl1.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            lbl1.leadingAnchor.constraint(equalTo: img.trailingAnchor, constant: 13),
            
            lbl2.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            lbl2.leadingAnchor.constraint(greaterThanOrEqualTo: lbl1.trailingAnchor, constant: 15),
            lbl2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
        
        return view
    }()
    
    let btn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("입장하기", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        btn.layer.cornerRadius = 5
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.addNavi(title: "")
        
        self.view.addSubview(titleLbl)
        self.view.addSubview(profileImg1)
        self.view.addSubview(contentLbl)
        self.view.addSubview(containerView)
        containerView.addSubview(roomInfoView)
        containerView.addSubview(msgView)
        roomInfoView.addSubview(profileImg2)
        roomInfoView.addSubview(roomTitle)
        roomInfoView.addSubview(roomSubTitle)
        roomInfoView.addSubview(activeMember)
        self.view.addSubview(btn)
        
        let guide = self.view.safeAreaLayoutGuide
        
        // self.view
        NSLayoutConstraint.activate([
            titleLbl.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20),
            titleLbl.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            titleLbl.trailingAnchor.constraint(greaterThanOrEqualTo: guide.trailingAnchor, constant: -20),
            
            profileImg1.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 20),
            profileImg1.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            contentLbl.topAnchor.constraint(equalTo: profileImg1.bottomAnchor, constant: 20),
            contentLbl.leadingAnchor.constraint(equalTo: titleLbl.leadingAnchor),
            contentLbl.trailingAnchor.constraint(greaterThanOrEqualTo: guide.trailingAnchor, constant: -20),
            
            containerView.topAnchor.constraint(equalTo: contentLbl.bottomAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16),
            
            btn.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -15),
            btn.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 15),
            btn.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -15),
            btn.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // containerView
        NSLayoutConstraint.activate([
            roomInfoView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 18),
            roomInfoView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 18),
            roomInfoView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -18),
            
            msgView.topAnchor.constraint(equalTo: roomInfoView.bottomAnchor, constant: 23),
            msgView.leadingAnchor.constraint(equalTo: roomInfoView.leadingAnchor),
            msgView.trailingAnchor.constraint(equalTo: roomInfoView.trailingAnchor),
            msgView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -18),
            msgView.heightAnchor.constraint(equalToConstant: 42)
        ])
        
        // roomInfoView
        NSLayoutConstraint.activate([
            profileImg2.topAnchor.constraint(equalTo: roomInfoView.topAnchor),
            profileImg2.leadingAnchor.constraint(equalTo: roomInfoView.leadingAnchor),
            profileImg2.widthAnchor.constraint(equalToConstant: 70),
            profileImg2.heightAnchor.constraint(equalToConstant: 70),
            profileImg2.bottomAnchor.constraint(equalTo: roomInfoView.bottomAnchor),
            
            roomTitle.topAnchor.constraint(equalTo: profileImg2.topAnchor),
            roomTitle.leadingAnchor.constraint(equalTo: profileImg2.trailingAnchor, constant: 12),
            roomTitle.trailingAnchor.constraint(greaterThanOrEqualTo: roomInfoView.trailingAnchor, constant: -10),
            
            roomSubTitle.topAnchor.constraint(equalTo: roomTitle.bottomAnchor, constant: 8),
            roomSubTitle.leadingAnchor.constraint(equalTo: roomTitle.leadingAnchor),
            roomSubTitle.trailingAnchor.constraint(greaterThanOrEqualTo: roomInfoView.trailingAnchor, constant: -10),
            
            activeMember.topAnchor.constraint(equalTo: roomSubTitle.bottomAnchor, constant: 8),
            activeMember.leadingAnchor.constraint(equalTo: roomTitle.leadingAnchor),
            activeMember.trailingAnchor.constraint(greaterThanOrEqualTo: roomInfoView.trailingAnchor, constant: -10),
        ])
    }
}


#if DEBUG
import SwiftUI

struct ForthVCPreView: PreviewProvider {
    static var previews: some View {
        ForthVC().toPreview().ignoresSafeArea()
    }
}
#endif
