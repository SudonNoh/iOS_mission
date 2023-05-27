//
//  Mocks.swift
//  mission02_API
//
//  Created by Sudon Noh on 2023/05/20.
//

import Foundation
import RxSwift
import RxRelay


class MocksVM {
    
    var disposeBag = DisposeBag()
    
    var mocks : BehaviorRelay<[Mock]> = BehaviorRelay<[Mock]>(value: [])
    var errorMsg : BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    
    var isLoading : BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)

    var pageInfo : BehaviorRelay<Meta?> = BehaviorRelay<Meta?>(value: nil)
    var notifyHasNextPage : Observable<Bool>
    
    var currentPage : BehaviorRelay<Int> = BehaviorRelay<Int>(value: 1)
    var currentPageInfo : Observable<String>
    
    var mock : BehaviorRelay<Mock?> = BehaviorRelay<Mock?>(value:nil)
    
    init() {
        
        self.notifyHasNextPage = pageInfo.skip(1).map {$0?.hasNext() ?? true}
        self.currentPageInfo = self.currentPage.map {"\($0)"}
        
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
        
        fetchMocks()
    }
    
    /// 전체보기
    func fetchMocks(
        _ page: Int = 1,
        _ orderBy: orderBy = .desc,
        _ perPage: Int = 10
    ) {
        
        if self.isLoading.value {
            return
        }
        
        self.isLoading.accept(true)
        
        Observable.just(())
            .delay(RxTimeInterval.milliseconds(700), scheduler: MainScheduler.instance)
            .flatMapLatest {MocksAPI.fetchMocksAPI(page, orderBy, perPage)}
            .do(onError: { Error in
                self.errorMsg.accept(self.errorHandler(Error))
            }, onCompleted: {
                self.isLoading.accept(false)
            })
            .subscribe(onNext: { response in
                
                guard let fetchMocks = response.data,
                      let pageInfo = response.meta else { return }
                
                if page == 1 {
                    self.mocks.accept(fetchMocks)
                } else {
                    let addedMocks = self.mocks.value + fetchMocks
                    self.mocks.accept(addedMocks)
                }
                self.pageInfo.accept(pageInfo)
            })
            .disposed(by: disposeBag)
    }
    
    /// 더보기
    func fetchMocksMore() {
        
        guard let pageInfo = self.pageInfo.value,
              pageInfo.hasNext(),
              !isLoading.value else {
            return
        }

        self.fetchMocks(currentPage.value + 1)
    }
    
    /// 삭제
    func deleteMocksItem(id: Int) {
        var _mocks = self.mocks.value.filter { $0.id ?? 0 != id }
        self.mocks.accept(_mocks)
    }
    
    /// Error Handler
    fileprivate func errorHandler(_ err: Error) -> String {
        guard let apiError = err as? MocksAPI.APIError else {
            return ""
        }
        
        return apiError.info
    }
}
