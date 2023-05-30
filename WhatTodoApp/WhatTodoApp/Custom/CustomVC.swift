//
//  ViewController+Ext.swift
//  WhatTodoApp
//
//  Created by Sudon Noh on 2023/05/18.
//

import Foundation
import UIKit

class CustomVC : UIViewController {
    /// Status 상태바의 텍스트 색상을 하얀색으로 바꾸기 위해 추가
    override func viewDidAppear(_ animated: Bool) {
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
    
    @objc func showCompleteAlert(completion: (() -> Void)? = nil){
        let alert = UIAlertController(title: "완료", message: "정말로 완료하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "네", style: .default) {(_) in
            completion?()
        }
        let cancelAction = UIAlertAction(title: "아니요", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
}
