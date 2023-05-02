//
//  UIView+Ext.swift
//  UITableViewTutorial
//
//  Created by Sudon Noh on 2023/05/01.
//

import Foundation

#if DEBUG
import SwiftUI

extension UIView {
    private struct Preview: UIViewRepresentable {
        let view: UIView
        
        func makeUIView(context: Context) -> UIView {
            return view
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {
        }
    }
    
    func toPreview() -> some View {
        Preview(view: self)
    }
}
#endif
