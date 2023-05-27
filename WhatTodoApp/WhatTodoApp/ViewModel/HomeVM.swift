//
//  TodoVM.swift
//  WhatTodoApp
//
//  Created by Sudon Noh on 2023/05/19.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class HomeVM {
    
    var disposeBag = DisposeBag()
    
    var todoList: BehaviorRelay<[Todo]> = BehaviorRelay<[Todo]>(value: [])
    
    init() {
        fetchTodos(page: 1)
    }
    
    func fetchTodos(page: Int) {
        
        Observable.just(())
            .delay(RxTimeInterval.milliseconds(700), scheduler: MainScheduler.instance)
            .flatMapLatest { TodoAPI.fetchTodos(page) }
            .subscribe(onNext: { response in
                guard let data = response.data else { return }
                self.todoList.accept(data)
            })
            .disposed(by: disposeBag)
    }
}
