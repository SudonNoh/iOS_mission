//
//  TodosView.swift
//  TodoAppTutorial
//
//  Created by Sudon Noh on 2023/05/02.
//

import Foundation
import SwiftUI


struct TodosView: View {
    var body: some View {
        VStack(alignment: .leading) {
            getHeader()
            UISearchBarWrapper()
            Spacer()
            List {
                TodoRow()
                TodoRow()
                TodoRow()
                TodoRow()
                TodoRow()
                TodoRow()
                TodoRow()
                TodoRow()
                TodoRow()
                TodoRow()
            }.listStyle(.plain)
        }
    }
    
    fileprivate func getHeader() -> some View {
        Group{
            topHeader
            secondHeader
        }.padding(.horizontal, 10)
    }
    
    fileprivate var topHeader : some View {
        Group {
            Text("TodoCompletionView / page: 2")
            Text("선택된 할 일: []")
            HStack {
                Button(action: {print("클로저")}, label: {Text("클로저")})
                    .buttonStyle(MyDefaultBtnStyle())

                Button(action: {print("Rx")}, label: {Text("Rx")})
                    .buttonStyle(MyDefaultBtnStyle())
                
                Button(action: {print("콤바인")}, label: {Text("콤바인")})
                    .buttonStyle(MyDefaultBtnStyle())

                
                Button(action: {print("Async")}, label: {Text("Async")
                })
                    .buttonStyle(MyDefaultBtnStyle())
            }
        }
    }
    
    fileprivate var secondHeader : some View {
        Group {
            Text("Async 변환 액션들")
            HStack {
                Button(action: {print("클로저 ⇢ Async")}, label: {Text("클로저 ⇢ Async")})
                    .buttonStyle(MyDefaultBtnStyle(numberOfLines: 2))
                Button(action: {print("Rx ⇢ Async")}, label: {Text("Rx ⇢ Async")})
                    .buttonStyle(MyDefaultBtnStyle(numberOfLines: 2))
                Button(action: {print("콤바인 ⇢ Async")}, label: {Text("콤바인 ⇢ Async")})
                    .buttonStyle(MyDefaultBtnStyle(numberOfLines: 2))
            }
            HStack {
                Button(action: {print("초기화")}, label: {Text("초기화")})
                    .buttonStyle(MyDefaultBtnStyle(bgColor: .purple))
                Button(action: {print("선택된 할 일들 삭제")}, label: {Text("선택된 할 일들 삭제")})
                    .buttonStyle(MyDefaultBtnStyle(bgColor: .black, numberOfLines: 2))
                Button(action: {print("할 일 추가")}, label: {Text("할 일 추가")})
                    .buttonStyle(MyDefaultBtnStyle(bgColor: .gray))
            }
        }
    }
}


struct TodosView_Previews: PreviewProvider {
    
    static var previews: some View {
        TodosView()
    }
}
