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

class HomeVM : CustomVM {
    
    var disposeBag = DisposeBag()
    
    var todoList: BehaviorRelay<[Todo]> = BehaviorRelay<[Todo]>(value: [])
    var errorMsg : PublishRelay<String> = PublishRelay()
    
    var isLoading : BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    var pageInfo : BehaviorRelay<Meta?> = BehaviorRelay<Meta?>(value: nil)
    var notifyHasNextPage : Observable<Bool>
    
    var currentPage : BehaviorRelay<Int> = BehaviorRelay<Int>(value: 1)
    var currentPageInfo : Observable<String>
    
    override init() {
        self.notifyHasNextPage = pageInfo.skip(1).map { $0?.hasNext() ?? true  }
        self.currentPageInfo = currentPage.map { "\($0)" }
        
        super.init()

        pageInfo
            .compactMap { $0 }
            .map {
                if let currentPage = $0.currentPage {
                    return currentPage
                } else {
                    return 1
                }
            }
            .bind(onNext: self.currentPage.accept(_:))
            .disposed(by: disposeBag)
        
        fetchTodos(page: 1)
    }
    
    // 데이터 가져오기
    func fetchTodos(page: Int = 1, orderBy: orderBy = .desc, perPage: Int = 10) {
        
        if self.isLoading.value {
            return
        }
        
        self.isLoading.accept(true)
        
        Observable.just(())
            .delay(RxTimeInterval.milliseconds(700), scheduler: MainScheduler.instance)
            .flatMapLatest { TodoAPI.fetchTodos(page, orderBy, perPage) }
            .subscribe(onNext: { response in
                guard let data = response.data,
                      let pageInfo = response.meta else { return }
                
                if page == 1 {
                    self.todoList.accept(data)
                } else {
                    let addTodos = self.todoList.value + data
                    self.todoList.accept(addTodos)
                }
                self.pageInfo.accept(pageInfo)
                
            }, onError: { Error in
                self.errorMsg.accept(self.errorHandler(Error))
                self.isLoading.accept(false)
            }, onCompleted: {
                self.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    // 데이터 더 가져오기
    func fetchMoreTodos() {
        guard let pageInfo = self.pageInfo.value,
              pageInfo.hasNext(),
              !isLoading.value else { return }
        self.fetchTodos(page: currentPage.value + 1)
    }
}
