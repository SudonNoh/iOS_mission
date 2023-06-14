//
//  ViewController+Ext.swift
//  WhatTodoApp
//
//  Created by Sudon Noh on 2023/05/18.
//

import Foundation
import UIKit

class CustomVC : UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.barStyle = .black
    }
}

extension CustomVC {
    @objc func showErrorAlert(errMsg: String){
        let alert = UIAlertController(title: "안내", message: errMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func showDeleteAlert(completion: (() -> Void)? = nil){
        let alert = UIAlertController(title: "삭제", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "네", style: .default) {(_) in
            completion?()
        }
        let cancelAction = UIAlertAction(title: "아니요", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    @objc func showCompleteAlert(message: String, completion: (() -> Void)? = nil){
        let alert = UIAlertController(title: "저장", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "네", style: .default) {(_) in
            completion?()
        }
        let cancelAction = UIAlertAction(title: "아니요", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    @objc func showSaveAlert(completion: (()-> Void)? = nil, cancelCompletion: (()->Void)? = nil) {
        let alert = UIAlertController(title: "저장", message: "저장하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "저장", style: .default) {(_) in
            completion?()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) {(_) in
            cancelCompletion?()
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated:true)
    }
    
    @objc func showDoneAlert(completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "완료", message: "저장되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) {(_) in
            completion?()
        }
        alert.addAction(okAction)
        self.present(alert, animated:true)
    }
}
