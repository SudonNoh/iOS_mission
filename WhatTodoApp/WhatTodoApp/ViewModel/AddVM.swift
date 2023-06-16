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
    
    var todo: PublishRelay<Todo> = PublishRelay()
    
    var errorMsg: PublishRelay<String> = PublishRelay()
    
    var isLoadingAction: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    func addATodo(title: String, isDone: Bool) {
        
        if self.isLoadingAction.value {
            return
        }
        
        self.isLoadingAction.accept(true)
        
        TodoAPI.addATodo(title: title, isDone: isDone)
            .withUnretained(self)
            .subscribe(onNext: {(_, TodoResponse) in
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
