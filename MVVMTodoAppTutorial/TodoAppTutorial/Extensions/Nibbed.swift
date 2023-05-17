//
//  Nibbed.swift
//  TodoAppTutorial
//
//  Created by Sudon Noh on 2023/05/13.
//

import Foundation
import UIKit

//MARK: - Nibbed 이름 설정
protocol Nibbed {
    static var uiNib: UINib { get }
}

extension Nibbed {
    static var uiNib: UINib {
        return UINib(nibName: String(describing: Self.self), bundle: nil)
    }
}

extension UITableViewCell : Nibbed { }
