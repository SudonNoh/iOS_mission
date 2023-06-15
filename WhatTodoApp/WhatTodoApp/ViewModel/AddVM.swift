//
//  AddVM.swift
//  WhatTodoApp
//
//  Created by Sudon Noh on 2023/06/15.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class AddVM: CustomVM {
    var disposeBag = DisposeBag()
    
    override init() {
        super.init()
        self.addATodo(title: "자동으로 추가된 항목입니다.", isDone: true)
    }
    
    func addATodo(title: String, isDone: Bool) {
        TodoAPI.addATodo(title: title, isDone: isDone)
            .withUnretained(self)
            .subscribe(onNext: {(VM, data) in
                print(VM)
                print(data)
            })
            .disposed(by: disposeBag)
    }
}
