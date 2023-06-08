//
//  EditVC.swift
//  WhatTodoApp
//
//  Created by Sudon Noh on 2023/05/30.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import RxRelay
import SnapKit
import Then


class EditVC: CustomVC {
    
    var data: Todo? = nil
    
    lazy var countTextLbl: UILabel = UILabel().then {
        $0.text = "0/5"
        $0.textColor = .red
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textAlignment = .center
    }
    
    //MARK: - TextView Edit Error
    /*
     TextField 부분에 입력될 때 입력 속도가 맞지 않아 발생하는 거 같다. 확실히 파악하지 못했음.
     2023-05-31 09:41:45.256793+0900 WhatTodoApp[1796:28520] [Query] Error for queryMetaDataSync: 2
     2023-05-31 09:41:45.258201+0900 WhatTodoApp[1796:28520] [Query] Error for queryMetaDataSync: 2
    */
    lazy var titleTextView: UITextView = UITextView().then {
        $0.text = "여섯 글자 이상 입력해주세요."
        $0.textColor = .systemGray
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.backgroundColor = .bgColor
        $0.textInputView.backgroundColor = .bgColor
        $0.contentInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        $0.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        $0.layer.borderColor = UIColor.textPoint?.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 5
    }
    
    lazy var dateStackView: UIStackView = UIStackView().then {
        $0.spacing = 5
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.addArrangedSubview(updateDateLbl)
        $0.addArrangedSubview(createDateLbl)
    }
    
    lazy var updateDateLbl: UILabel = UILabel().then {
        $0.text = "Update: 9999-99-99 00시 00분"
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .textColor
        $0.textAlignment = .center
    }
    
    lazy var createDateLbl: UILabel = UILabel().then {
        $0.text = "Create: 9999-99-99 00시 00분"
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .textColor
        $0.textAlignment = .center
    }
    
    lazy var saveBtn: UIButton = UIButton().then {
        $0.setTitle("Save", for: .normal)
        $0.setTitleColor(.textPoint, for: .normal)
        $0.backgroundColor = .bgColor
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor.textPoint?.cgColor
        $0.layer.borderWidth = 1
    }
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
/* placeHolder를 사용해야 하는 경우 설정
//        self.titleTextView.rx.didBeginEditing.subscribe(onNext: {
//            self.titleTextView.text = ""
//            self.titleTextView.textColor = .textColor
//        })
//        .disposed(by: disposeBag)
*/
        
        self.titleTextView.rx.didEndEditing.subscribe(onNext: {
            // 글자 수가 모자란 경우
            if self.titleTextView.text.count == 0 {
                self.titleTextView.text = "여섯 글자 이상 입력해주세요."
                self.titleTextView.textColor = .systemGray
            }
        })
        .disposed(by: disposeBag)
        
        self.titleTextView.rx.didChange.subscribe(onNext: {
            self.changeCount()
        })
        .disposed(by: disposeBag)
        
        self.saveBtn.rx.tap.subscribe(onNext: {
            self.saveBtn.backgroundColor = .white
            self.saveBtn.setTitleColor(.black, for: .normal)
        })
        .disposed(by: disposeBag)
    }
    
}

extension EditVC {
    func setup() {
        self.view.backgroundColor = .bgColor
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.title = "List"
        
        let safeArea = self.view.safeAreaLayoutGuide.snp
        
        self.view.addSubview(titleTextView)
        self.view.addSubview(countTextLbl)
        self.view.addSubview(dateStackView)
        self.view.addSubview(saveBtn)

        titleTextView.snp.makeConstraints {
            $0.top.equalTo(safeArea.top)
            $0.horizontalEdges.equalTo(safeArea.horizontalEdges).inset(15)
        }
        
        countTextLbl.snp.makeConstraints {
            $0.top.equalTo(titleTextView.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(titleTextView.snp.horizontalEdges)
        }

        dateStackView.snp.makeConstraints {
            $0.top.equalTo(countTextLbl.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(titleTextView.snp.horizontalEdges)
        }

        saveBtn.snp.makeConstraints {
            $0.top.equalTo(dateStackView.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(titleTextView.snp.horizontalEdges)
            $0.height.equalTo(40)
            $0.bottom.equalTo(safeArea.bottom).inset(15)
        }

        guard let data = self.data,
              let id = data.id,
              let title = data.title,
              let createDate = data.createdAt,
              let updateDate = data.updatedAt else { return }
        
        self.navigationItem.title = "ID : \(id)"
        self.titleTextView.text = title
        self.titleTextView.textColor = .textColor
        self.updateDateLbl.text = dateFormatter(frontString: "Update:", date: updateDate)
        self.createDateLbl.text = dateFormatter(frontString: "Create:", date: createDate)
        
        self.changeCount()
    }
}

extension EditVC {
    /// 글자 수가 5개 이하인 경우 빨간 글씨가 뜨도록 설정
    fileprivate func changeCount() {
        let count = self.titleTextView.text.count
        self.countTextLbl.text = "\(count)/5"
        
        if count > 5 {
            self.countTextLbl.textColor = .green
        } else {
            self.countTextLbl.textColor = .red
        }
    }
}
