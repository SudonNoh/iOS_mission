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
    
    var todo: BehaviorRelay<Todo?> = BehaviorRelay<Todo?>(value: nil)
    
    var isLoadingBottom : BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var isLoadingAction : BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    var pageInfo : BehaviorRelay<Meta?> = BehaviorRelay<Meta?>(value: nil)
    var notifyHasNextPage : Observable<Bool>
    
    var currentPage : BehaviorRelay<Int> = BehaviorRelay<Int>(value: 1)
    var currentPageInfo : Observable<String>
    
    var orderByStatus: OrderBy = .desc
    var isDoneStatus: Bool? = true
    
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
    func fetchTodos(page: Int = 1, filterBy: String = "created_at", orderBy: OrderBy = .desc, isDone: Bool? = nil, perPage: Int = 10) {
        
        if self.isLoadingBottom.value {
            return
        }
        
        self.isLoadingBottom.accept(true)
        
        Observable.just(())
            .delay(RxTimeInterval.milliseconds(700), scheduler: MainScheduler.instance)
            .flatMapLatest { TodoAPI.fetchTodos(page, filterBy, orderBy, isDone, perPage) }
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
                self.isLoadingBottom.accept(false)
            }, onCompleted: {
                self.isLoadingBottom.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    // 데이터 더 가져오기
    func fetchMoreTodos() {
        guard let pageInfo = self.pageInfo.value,
              pageInfo.hasNext(),
              !isLoadingBottom.value else { return }
        
        self.fetchTodos(page: currentPage.value + 1, orderBy: orderByStatus, isDone: isDoneStatus)
    }
    
    // 데이터 삭제하기
    func deleteATodo(id: Int) {
        if self.isLoadingAction.value {
            return
        }
        
        self.isLoadingAction.accept(true)
        
        TodoAPI.deleteATodo(id: id)
            .withUnretained(self)
            .subscribe ( onNext: { _, _ in
                let _todoList = self.todoList.value.filter { $0.id ?? 0 != id }
                self.todoList.accept(_todoList)
            }, onError: { Error in
                self.errorMsg.accept(self.errorHandler(Error))
                self.isLoadingAction.accept(false)
            }, onCompleted: {
                self.isLoadingAction.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    // 데이터 수정하기
    func updateATodo(id: Int, title: String, isDone: Bool) {
        if self.isLoadingAction.value {
            return
        }
        
        self.isLoadingAction.accept(true)
        
        TodoAPI.updateATodo(id: id, title: title, isDone: isDone)
            .withUnretained(self)
            .subscribe ( onNext: { (HomeVM, TodoResponse) in
                var _todoList = self.todoList.value
                //MARK: - 업데이트 방식, TodoResponse에 있는 isDone, title, updatedAt을 var로 변경
                guard let data = TodoResponse.data,
                      let id = data.id,
                      let idx = _todoList.firstIndex(where: { $0.id == id }) else { return }
                
                _todoList[idx].isDone = data.isDone
                _todoList[idx].title = data.title
                _todoList[idx].updatedAt = data.updatedAt
                
                self.todoList.accept(_todoList)
            }, onError: { Error in
                self.errorMsg.accept(self.errorHandler(Error))
                self.isLoadingAction.accept(false)
            }, onCompleted: {
                self.isLoadingAction.accept(false)
            })
            .disposed(by: disposeBag)
    }
}
