//
//  ViewController+Ext.swift
//  mission_01-2
//
//  Created by Sudon Noh on 2023/04/12.
//

import Foundation
import UIKit



extension UIViewController {
    @objc func clickedLeftArrow() {
        print(#fileID, #function, #line, "- Left Arrow Clicked!")
    }
    
    @objc func clickedRightArrow() {
        print(#fileID, #function, #line, "- Right Arrow Clicked!")
    }
}

extension UIViewController {
    
    /// Navigation Options
    func addNavi(title: String) {
        self.title = title
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(clickedLeftArrow)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.right"),
            style: .plain,
            target: self,
            action: #selector(clickedRightArrow)
        )
        
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        navigationController?.navigationBar.backgroundColor = .systemGray6
    }
}



#if DEBUG
import SwiftUI

extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }
    
    func toPreview() -> some View {
        Preview(viewController: self)
    }
}
#endif
