//
//  ReuseIdentifiable.swift
//  TodoAppTutorial
//
//  Created by Sudon Noh on 2023/05/13.
//

import Foundation
import UIKit

//MARK: - ReuseIdentifier 이름 설정
protocol ReuseIdentifiable {
    static var reuseIdentifire: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifire: String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell : ReuseIdentifiable { }
