//
//  TodoCell.swift
//  TodoAppTutorial
//
//  Created by Sudon Noh on 2023/05/02.
//

import Foundation
import UIKit

class TodoCell : UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var selectionSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionSwitch.addTarget(self, action: #selector(onSelectionChanged(_:)), for: .valueChanged)
    }
    
    var cellData : Todo? = nil
    
    // 삭제 액션
    var onDeleteActionEvent: ((Int) -> Void)? = nil
    
    // 수정 액션
    var onEditActionEvent: ((_ id: Int, _ title: String) -> Void)? = nil
    
    // 선택 액션
    var onSelectedActionEvent: ((_ id: Int, _ isOn: Bool) -> Void)? = nil
    
    /// Cell Data 적용
    /// - Parameter cellData: Todo
    func updateUI(_ cellData: Todo, _ seletedTodoIds: Set<Int>) {
        
        guard let id = cellData.id,
              let title = cellData.title
        else {
            print("id, title이 없습니다.")
            return
        }
        self.cellData = cellData
        
        self.titleLabel.text = "ID: \(id)"
        self.contentLabel.text = title
        self.selectionSwitch.isOn = seletedTodoIds.contains(id)
    }
    
    @objc fileprivate func onSelectionChanged(_ sender: UISwitch) {
        print(#fileID, #function, #line, "- sender: \(sender.isOn)")
        guard let id = cellData?.id else {return}
        self.onSelectedActionEvent?(id, sender.isOn)
    }
    
    @IBAction func onEditBtnClicked(_ sender: UIButton) {
        guard let id = cellData?.id,
              let title = cellData?.title else {return}
        
        self.onEditActionEvent?(id, title)
    }
    
    @IBAction func onDeleteBtnClicked(_ sender: UIButton) {
        guard let id = cellData?.id else {return}
        self.onDeleteActionEvent?(id)
    }
    
}
