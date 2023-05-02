//
//  StoryboardCell.swift
//  UITableViewTutorial
//
//  Created by Sudon Noh on 2023/05/01.
//

import Foundation
import UIKit

// DRY : Don't Repeat Yourself

//extension UITableViewCell {
//    static var reuseIdentifier: String {
//        // 자기 자신의 class명을 아래와 같이 불러온다.
//        return String(describing: Self.self)
//    }
//}
//
//extension UICollectionViewCell {
//    static var reuseIdentifier: String {
//        return String(describing: Self.self)
//    }
//}
//
//extension UITableViewHeaderFooterView {
//    static var reuseIdentifier: String {
//        return String(describing: Self.self)
//    }
//}

// 위 과정을 줄이기 위해 protocol을 사용한다.
/// reuseIdentifier 를 가진다.
protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell : ReuseIdentifiable { }

extension UICollectionViewCell : ReuseIdentifiable { }

extension UITableViewHeaderFooterView : ReuseIdentifiable { }


class StoryboardCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    // viewController 에서 viewDidLoad와 같은 기능
    override func awakeFromNib() {
        super.awakeFromNib()
        print(#fileID, #function, #line, "- awakeFromNib 실행")
        
        self.backgroundColor = .yellow
    }
}
