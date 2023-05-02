//
//  MyCellConfiguration.swift
//  UITableViewTutorial
//
//  Created by Sudon Noh on 2023/05/01.
//

import Foundation
import UIKit

// 데이터와 UI를 연결하는 설정
// 커스텀 셀에 대한 설정
struct MyCellConfiguration: UIContentConfiguration, Hashable {
    
    var title: String = "제목"
    var body: String = "본문"
    
    // 보여줄 화면
    func makeContentView() -> UIView & UIContentView {
        return CellConfigurationView(config: self)
    }
    
    /// 셀 상태가 변경되면 발동
    /// - Parameter state: 셀 상태
    /// - Returns: 셀 설정 자체
    func updated(for state: UIConfigurationState) -> MyCellConfiguration {
        
        if let state = state as? UICellConfigurationState {
            
            var updatedConfig = self
            
            if state.isSelected {
                updatedConfig.title = "선택됨 // " + updatedConfig.title
            }
            
            return updatedConfig
        }
        
        return self
    }
}
