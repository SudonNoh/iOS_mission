//
//  Button+Style.swift
//  TodoAppTutorial
//
//  Created by Sudon Noh on 2023/05/02.
//

import Foundation
import SwiftUI


struct MyDefaultBtnStyle: ButtonStyle {
    
    let bgColor: Color
    let textColor: Color
    let numberOfLines: Int
    
    init(bgColor: Color = Color.blue, textColor: Color = Color.white, numberOfLines: Int = 1) {
        self.bgColor = bgColor
        self.textColor = textColor
        self.numberOfLines = numberOfLines
    }
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
                .lineLimit(numberOfLines)
                .minimumScaleFactor(0.7)
                .foregroundColor(textColor)
            Spacer()
        }
        .padding()
        .background(bgColor.cornerRadius(8))
        .scaleEffect(configuration.isPressed ? 0.95 : 1 )
    }
}
