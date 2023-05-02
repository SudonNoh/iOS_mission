//
//  TodoRow.swift
//  TodoAppTutorial
//
//  Created by Sudon Noh on 2023/05/02.
//

import Foundation
import SwiftUI


struct TodoRow: View {
    
    @State var isSelected : Bool = false
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("ID / 완료여부")
                Text("오늘도 빡코딩")
            }.frame(maxWidth: .infinity)
            
            VStack(alignment: .trailing) {
                actionBtns
                Toggle(isOn: $isSelected, label: {
                    EmptyView()
                })
                .frame(width: 60)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    fileprivate var actionBtns: some View {
        HStack {
            Button(action: {}, label: {
                Text("수정")
            })
            .buttonStyle(MyDefaultBtnStyle())
            .frame(width: 80)
            
            Button(action: {}, label: {
                Text("삭제")
            })
            .buttonStyle(MyDefaultBtnStyle(bgColor: .purple))
            .frame(width: 80)
        }
    }
}


struct TodoRow_Previews: PreviewProvider {
    static var previews: some View {
        TodoRow()
    }
}
