import Foundation
import UIKit

// 기존 테이블 뷰 셀은 데이터만 신경쓰면 된다.
class CellConfigTableViewCell: UITableViewCell {
    
    // 데이터를 변경하면 설정을 변경해라! 라고 한다.
    var title: String = "" {
        didSet {
            setNeedsUpdateConfiguration()
        }
    }
    
    var body: String = "" {
        didSet {
            setNeedsUpdateConfiguration()
        }
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        // 내가 가지고 있는 데이터를 셀 config에 반영 -> 업데이트
        var contentConfig = MyCellConfiguration().updated(for: state)
        contentConfig.title = title
        contentConfig.body = body
        
        // 변경된 config 적용
        self.contentConfiguration = contentConfig
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print(#fileID, #function, #line, "- layoutSubviews")
    }
}
