import UIKit
import RxSwift
import RxRelay
import RxCocoa
import Foundation


extension Reactive where Base: UIScrollView {

    /// 바닥 여부
    var bottomReached: Observable<Void> {
        return contentOffset.map {(offset: CGPoint) in
            let height = self.base.frame.size.height
            let contentYOffset = offset.y
            let distanceFromBottom = self.base.contentSize.height - contentYOffset
            
            return distanceFromBottom - 200 < height
        }
        .filter { $0 == true }.map { _ in }
    }
}
