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
    
    init() {
        fetchMocks()
    }
    
    func fetchMocks(
        _ page: Int = 1,
        _ orderBy: orderBy = .desc,
        _ perPage: Int = 10
    ) {
        Observable.just(())
            .delay(RxTimeInterval.milliseconds(700), scheduler: MainScheduler.instance)
            .flatMapLatest {MocksAPI.fetchsMocks(page, orderBy, perPage)}
            .do(onError: { Error in
                self.errorMsg.accept(self.errorHandler(Error))
            })
            .subscribe(onNext: { response in
                if let fetchMocks = response.data {
                    self.mocks.accept(fetchMocks)
                }
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func errorHandler(_ err: Error) -> String {
        guard let apiError = err as? MocksAPI.APIError else {
            return ""
        }
        
        return apiError.info
    }
}
