//
//  ForthVC.swift
//  mission_01-2
//
//  Created by Sudon Noh on 2023/04/26.
//

import Foundation
import UIKit
import SnapKit
import Then


class ForthVC: UIViewController {
    
    lazy var titleLbl: UILabel = UILabel().then {
        $0.text = "오전, 오후 풀타임 빡코딩 스터디\n빡코딩 하는 사람만"
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.numberOfLines = 2
    }
    
    lazy var profileImg: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "profile1")
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var contentLbl: UILabel = UILabel().then {
        $0.text = "하루 10시간 이상 빡코딩 하실분 오세요~\n취준생, 현직 개발자, 이직을 위한 빡코딩, 취미 개발 등\n모두 환영입니다!"
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.numberOfLines = 3
    }
    
    lazy var containerView: UIView = UIView().then {
        $0.layer.shadowColor = UIColor(red: 0.37, green: 0.39, blue: 0.40, alpha: 1.00).cgColor
        $0.layer.shadowOpacity = 0.19
        $0.layer.shadowRadius = 15.0
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12.0
        
        $0.addSubview(roomInfoView)
        $0.addSubview(msgBoxView)
        
        roomInfoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        msgBoxView.snp.makeConstraints {
            $0.top.equalTo(roomInfoView.snp.bottom)
            $0.leading.equalTo(roomInfoView.snp.leading).offset(18)
            $0.trailing.equalTo(roomInfoView.snp.trailing).inset(18)
            $0.height.equalTo(42)
        }
    }
    
    lazy var roomInfoView: UIView = UIView().then {
        $0.backgroundColor = .white
        
        let profileImg: UIImageView = UIImageView().then {
            $0.image = UIImage(named: "profile2")
            $0.contentMode = .scaleAspectFit
        }
        
        let starImg: UIImageView = UIImageView().then {
            $0.image = UIImage(named: "star")
            $0.contentMode = .scaleAspectFit
        }
        
        let title: UILabel = UILabel().then {
            $0.text = "풀타임 빡코 모임방"
            $0.font = UIFont.boldSystemFont(ofSize: 14)
        }
        
        let subTitle: UILabel = UILabel().then {
            $0.text = "24시간 빡코딩 할 분들 모집합니다!"
            $0.textColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            $0.font = UIFont.boldSystemFont(ofSize: 14)
        }
        
        let number1: UILabel = UILabel().then {
            $0.text = "활동 중 멤버 249명"
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textColor = .blue
        }
        
        let number2: UILabel = UILabel().then {
            $0.text = "/ 정원 250명"
            $0.font = UIFont.systemFont(ofSize: 12)
        }
        
        $0.addSubview(profileImg)
        $0.addSubview(starImg)
        $0.addSubview(title)
        $0.addSubview(subTitle)
        $0.addSubview(number1)
        $0.addSubview(number2)
        
        profileImg.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(18)
            $0.width.height.equalTo(70)
        }
        
        starImg.snp.makeConstraints {
            $0.trailing.equalTo(profileImg.snp.trailing)
            $0.bottom.equalTo(profileImg.snp.bottom)
            $0.height.width.equalTo(24)
        }
        
        title.snp.makeConstraints {
            $0.top.equalTo(profileImg.snp.top)
            $0.leading.equalTo(profileImg.snp.trailing).offset(12)
            $0.trailing.greaterThanOrEqualToSuperview().inset(12)
        }
        
        subTitle.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(8)
            $0.leading.equalTo(title.snp.leading)
            $0.trailing.greaterThanOrEqualTo(title.snp.trailing)
        }
        
        number1.snp.makeConstraints {
            $0.top.equalTo(subTitle.snp.bottom).offset(8)
            $0.leading.equalTo(title.snp.leading)
        }
        
        number2.snp.makeConstraints {
            $0.top.equalTo(number1.snp.top)
            $0.leading.equalTo(number1.snp.trailing).offset(5)
        }
    }
    
    lazy var msgBoxView: UIView = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        $0.layer.cornerRadius = 5
        
        let img: UIImageView = UIImageView().then {
            $0.image = UIImage(named: "anonymous")
            $0.contentMode = .scaleAspectFit
        }
        
        let lbl1: UILabel = UILabel().then {
            $0.text = "빡코딩님의 메세지가 있습니다."
            $0.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            $0.font = UIFont.systemFont(ofSize: 12)
        }
        
        let lbl2: UILabel = UILabel().then {
            $0.text = "22시간 전"
            $0.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            $0.font = UIFont.systemFont(ofSize: 12)
        }
        
        $0.addSubview(img)
        $0.addSubview(lbl1)
        $0.addSubview(lbl2)
        
        img.snp.makeConstraints {
            $0.height.width.equalTo(26)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        lbl1.snp.makeConstraints {
            $0.leading.equalTo(img.snp.trailing).offset(13)
            $0.centerY.equalToSuperview()
        }
        
        lbl2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(lbl1.snp.trailing).offset(15)
            $0.trailing.equalToSuperview().inset(15)
        }
    }
    
    lazy var btn: UIButton = UIButton().then {
        $0.setTitle("입장하기", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        $0.backgroundColor = #colorLiteral(red: 0.2924042046, green: 0.518769145, blue: 0.9441746473, alpha: 1)
        $0.layer.cornerRadius = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(titleLbl)
        self.view.addSubview(profileImg)
        self.view.addSubview(contentLbl)
        self.view.addSubview(containerView)
        self.view.addSubview(btn)
        
        titleLbl.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.greaterThanOrEqualToSuperview().inset(20)
        }
        
        profileImg.snp.makeConstraints {
            $0.top.equalTo(titleLbl.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        contentLbl.snp.makeConstraints {
            $0.top.equalTo(profileImg.snp.bottom).offset(20)
            $0.leading.equalTo(titleLbl.snp.leading)
            $0.trailing.greaterThanOrEqualToSuperview().inset(20)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(contentLbl.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(msgBoxView.snp.bottom).offset(18)
        }
        
        btn.snp.makeConstraints {
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(18)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).inset(18)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(18)
            $0.height.equalTo(40)
        }
    }
}
