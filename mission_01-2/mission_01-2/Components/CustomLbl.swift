//
//  CustomLbl.swift
//  mission_01-2
//
//  Created by Sudon Noh on 2023/04/15.
//

import Foundation
import UIKit

class dot: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(txt:String) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = txt
        self.textAlignment = .center
    }
}

class contentLbl: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(txt:String) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = txt
        self.textAlignment = .left
        self.numberOfLines = 0
        self.font = UIFont.systemFont(ofSize: 16)
    }
}
