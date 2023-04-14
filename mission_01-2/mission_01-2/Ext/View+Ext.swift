//
//  View+Ext.swift
//  mission_01-2
//
//  Created by Sudon Noh on 2023/04/14.
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
