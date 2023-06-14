//
//  EditVM.swift
//  WhatTodoApp
//
//  Created by Sudon Noh on 2023/05/30.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class EditVM : CustomVM {
    var disposeBag = DisposeBag()
    
    var isLoadingAction : BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    var errorMsg : PublishRelay<String> = PublishRelay()
    
    var todo: PublishRelay<Todo> = PublishRelay()
    
    func updateATodo(id: Int, title: String, isDone: Bool) {
        if self.isLoadingAction.value {
            return
        }
        
        self.isLoadingAction.accept(true)
        
        TodoAPI.updateATodo(id: id, title: title, isDone: isDone)
            .withUnretained(self)
            .subscribe ( onNext: { (HomeVM, TodoResponse) in
                guard let data = TodoResponse.data else {return}
                
                self.todo.accept(data)
            }, onError: { Error in
                self.errorMsg.accept(self.errorHandler(Error))
                self.isLoadingAction.accept(false)
            }, onCompleted: {
                self.isLoadingAction.accept(false)
            })
            .disposed(by: disposeBag)
    }
}
