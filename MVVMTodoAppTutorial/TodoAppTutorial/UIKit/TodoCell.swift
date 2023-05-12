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
        print(#fileID, #function, #line, "-")
    }
    
    @IBAction func onEditBtnClicked(_ sender: UIButton) {
        print(#fileID, #function, #line, "- ")
    }
    @IBAction func onDeleteBtnClicked(_ sender: UIButton) {
        print(#fileID, #function, #line, "- ")
    }
    
}
