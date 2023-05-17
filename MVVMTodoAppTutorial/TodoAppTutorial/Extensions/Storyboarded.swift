//
//  Storyboarded.swift
//  TodoAppTutorial
//
//  Created by Sudon Noh on 2023/05/13.
//

import Foundation
import UIKit

extension UIViewController: StoryBoarded { }

protocol StoryBoarded {
    static func instantiate(_ storyboardName: String?) -> Self
}

extension StoryBoarded {
    static func instantiate(_ storyboardName: String? = nil) -> Self {
        let name = storyboardName ?? String(describing: Self.self)
        print(#fileID, #function, #line, "- \(name)")
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! Self
    }
}
