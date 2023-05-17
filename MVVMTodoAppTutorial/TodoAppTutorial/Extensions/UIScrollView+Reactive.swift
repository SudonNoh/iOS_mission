import UIKit
import RxSwift
import RxRelay
import RxCocoa
import Foundation


extension Reactive where Base: UIScrollView {
    
    /// 바닥 여부
//    var isNearBottom: Observable<Bool> {
//        return contentOffset.map {(offset: CGPoint) in
//            let height = self.base.frame.size.height
//            let contentYOffset = offset.y
//            let distanceFromBottom = self.base.contentSize.height - contentYOffset
//
//            return distanceFromBottom - 200 < height
//        }
//    }
    
    /// 바닥 여부
    var bottomReached: Observable<Void> {
        return contentOffset.map {(offset: CGPoint) in
            let height = self.base.frame.size.height
            let contentYOffset = offset.y
            let distanceFromBottom = self.base.contentSize.height - contentYOffset
            
            return distanceFromBottom - 200 < height
        }
        // 위에서 내려온 값이 true일 때만 이벤트를 보낸다 !
        .filter { $0 == true }.map { _ in }
    }
}
