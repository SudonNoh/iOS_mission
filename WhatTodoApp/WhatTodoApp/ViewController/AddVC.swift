//
//  AddVC.swift
//  WhatTodoApp
//
//  Created by Sudon Noh on 2023/05/18.
//

import Foundation
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa


class AddVC: CustomVC {
    
    weak var delegate: SendDataDelegate?
    
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
    lazy var saveBtn: UIButton = UIButton().then {
        $0.setTitle("Save", for: .normal)
        $0.setTitleColor(.textPoint, for: .normal)
        $0.setTitleColor(.systemRed, for: .disabled)
        $0.setTitleColor(.systemGreen, for: .selected)
        $0.backgroundColor = .bgColor
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor.textPoint?.cgColor
        $0.layer.borderWidth = 1
        $0.isEnabled = false
    }
    
    lazy var actionIndicator : UIActivityIndicatorView = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.color = UIColor.systemGray
        $0.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        $0.center = self.view.center
        $0.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
    }
    
    var disposeBag = DisposeBag()
    
    var viewModel = AddVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        self.titleTextView
            .rx
            .didBeginEditing
            .subscribe(onNext: {
                if self.titleTextView.text == "여섯 글자 이상 입력해주세요." {
                    self.titleTextView.text = ""
                    self.titleTextView.textColor = .textColor
                }
            })
            .disposed(by: disposeBag)
        
        self.titleTextView
            .rx
            .didEndEditing
            .subscribe(onNext: {
                if self.titleTextView.text.count == 0 {
                    self.titleTextView.text = "여섯 글자 이상 입력해주세요."
                    self.titleTextView.textColor = .systemGray
                }
            })
            .disposed(by: disposeBag)
        
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
            .bind { self.saveATodo() }
            .disposed(by: disposeBag)
        
        self.viewModel
            .todo
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind { (_, todo) in self.showDoneAlert() {
                guard let delegate = self.delegate else { return }
                delegate.refreshList(true)
                self.navigationController?.popViewController(animated: true)
            }}
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

extension AddVC {
    func setup() {
        self.view.backgroundColor = .bgColor
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.title = "List"
        self.navigationItem.title = "할 일 추가하기"
        
        let safeArea = self.view.safeAreaLayoutGuide.snp
        
        self.view.addSubview(titleTextView)
        self.view.addSubview(countTextLbl)
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

        saveBtn.snp.makeConstraints {
            $0.top.equalTo(countTextLbl.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(titleTextView.snp.horizontalEdges)
            $0.height.equalTo(40)
            $0.bottom.equalTo(safeArea.bottom).inset(15)
        }
    }
}

extension AddVC {
    func saveATodo() {
        self.saveBtn.isSelected = true
        self.showSaveAlert(completion: {
            
            self.titleTextView.isEditable = false
            
            guard let title = self.titleTextView.text else { return }
            
            self.viewModel.addATodo(title: title, isDone: false)
            
            self.saveBtn.isSelected = false
            self.titleTextView.isEditable = true
            
        }, cancelCompletion: {self.saveBtn.isSelected = false})
    }
}
