//
//  NibCell.swift
//  UITableViewTutorial
//
//  Created by Sudon Noh on 2023/05/01.
//

import Foundation
import UIKit

protocol Nibbed {
    static var uiNib : UINib { get }
}

extension Nibbed {
    static var uiNib : UINib {
        return UINib(nibName: String(describing: Self.self), bundle: nil)
    }
}

extension UITableViewCell : Nibbed { }

class NibCell : UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print(#fileID, #function, #line, "- NibCell")
        
        self.backgroundColor = .systemBlue
    }
}


