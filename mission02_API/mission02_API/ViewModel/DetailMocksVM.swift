//
//  Mocks.swift
//  mission02_API
//
//  Created by Sudon Noh on 2023/05/20.
//

import Foundation
import RxSwift
import RxRelay


class DetailMocksVM {
    
    var disposeBag = DisposeBag()
    
    fileprivate var _mock : BehaviorRelay<Mock?> = BehaviorRelay<Mock?>(value:nil)
    var errorMsg : BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    
    var mock : Observable<Mock> = Observable.empty()
    
    init(id: String = "1") {
        fetchAMock(id: id)
        
        mock = _mock.compactMap { $0 }
    }
    
    /// 특정 id 보기
    func fetchAMock(id: String = "1") {
        MocksAPI.fetchAMockAPI(id: id)
            .withUnretained(self)
            .do(onError: { Error in
                self.errorMsg.accept(self.errorHandler(Error))
            })
            .subscribe(onNext: { response in
                self._mock.accept(response.1.data)
            })
            .disposed(by: disposeBag)
    }
    
    /// Error Handler
    fileprivate func errorHandler(_ err: Error) -> String {
        guard let apiError = err as? MocksAPI.APIError else {
            return ""
        }
        
        return apiError.info
    }
}
