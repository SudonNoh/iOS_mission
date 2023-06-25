//
//  EditVC.swift
//  WhatTodoApp/ViewController/EditVC.swift
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
    
    weak var delegate: SendDataDelegate?
    
    var data: Todo? = nil
    
    lazy var countTextLbl: UILabel = UILabel().then {
        $0.text = "0/5"
        $0.textColor = .red
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textAlignment = .center
    }
    
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
    
    lazy var actionIndicator : UIActivityIndicatorView = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.color = UIColor.systemGray
        $0.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        $0.center = self.view.center
        $0.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
    }
    
    lazy var saveBtn: UIButton = UIButton().then {
        $0.setTitle("Save", for: .normal)
        $0.setTitleColor(.textPoint, for: .normal)
        $0.setTitleColor(.systemRed, for: .disabled)
        $0.setTitleColor(.systemGreen, for: .selected)
        $0.backgroundColor = .bgColor
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor.textPoint?.cgColor
        $0.layer.borderWidth = 1
    }
    
    var viewModel = EditVM()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
        self.titleTextView.rx
            .didChange
            .bind {
                changeCount(textView: self.titleTextView,
                            textLabel: self.countTextLbl,
                            button: self.saveBtn)
            }
            .disposed(by: disposeBag)
        
        self.saveBtn.rx
            .tap
            .bind {self.updateATodo()}
            .disposed(by: disposeBag)
        
        self.viewModel
            .todo
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind { (_, todo) in self.showDoneAlert() {
                guard let delegate = self.delegate else {return}
                delegate.refreshList(true)
                self.navigationController?.popViewController(animated: true)
            } }
            .disposed(by: disposeBag)
        
        self.viewModel
            .errorMsg
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { VC, msg in
                VC.showErrorAlert(errMsg: msg)
                self.titleTextView.isEditable = true
            }).disposed(by: disposeBag)
        
        self.viewModel
            .isLoadingAction
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _, isLoadingAction in
                isLoadingAction ? self.actionIndicator.startAnimating() : self.actionIndicator.stopAnimating()
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
        self.view.addSubview(actionIndicator)

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
        
        changeCount(textView: self.titleTextView,
                    textLabel: self.countTextLbl,
                    button: self.saveBtn)
    }
}

extension EditVC {
    func updateATodo() {
        self.saveBtn.isSelected = true
        self.showSaveAlert(completion: {
            
            self.titleTextView.isEditable = false
            
            guard let data = self.data,
                  let id = data.id,
                  let isDone = data.isDone,
                  let title = self.titleTextView.text else { return }
            
            self.viewModel.updateATodo(id: id, title: title, isDone: isDone)
            
            self.saveBtn.isSelected = false
            self.titleTextView.isEditable = true

        }, cancelCompletion: {self.saveBtn.isSelected = false})
    }
}

