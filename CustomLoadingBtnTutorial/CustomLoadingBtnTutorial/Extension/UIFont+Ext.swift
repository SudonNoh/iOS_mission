//
//  UIFont+Ext.swift
//  CustomLoadingBtnTutorial
//
//  Created by Sudon Noh on 2023/04/06.
//

import Foundation
import UIKit

extension UIFont {
    public enum SunflowerType: String {
        case medium = "-Medium"
        case light = "-Light"
        case bold = "-Bold"
    }
    
    static func Sunflower(_ type: SunflowerType = .medium, size: CGFloat = UIFont.systemFontSize) -> UIFont {
        return UIFont(name: "Sunflower\(type.rawValue)", size: size)!
    }
}
