//
//  TodoAppTutorialApp.swift
//  TodoAppTutorial
//
//  Created by Sudon Noh on 2023/05/02.
//

import SwiftUI

@main
struct TodoAppTutorialApp: App {
    
    // Tab 선택, 빌드되었을 때 Tab 우선순위 설정
    @State var selectedTab: Int = 1
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                
                TodosView()
                    .tabItem {
                        Image(systemName: "1.square.fill")
                        Text("SwiftUI")
                    }
                    .tag(0)
                
                MainVC.instantiate()
                    .getRepresentable()
                    .tabItem {
                        Image(systemName: "2.square.fill")
                        Text("UIKit")
                    }
                    .tag(1)
            }
        }
    }
}
