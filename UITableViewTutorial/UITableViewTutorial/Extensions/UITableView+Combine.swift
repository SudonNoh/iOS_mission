//
//  UITableView+Combine.swift
//  UITableViewTutorial
//
//  Created by Sudon Noh on 2023/05/01.
//

import Foundation
import UIKit
import Combine

extension UITableView {
    
    // 데이터 소스 바인딩
    // 과정 3: "과정 2"에서 보낸 데이터를 [DummyData]로 받는다.
    /* // CustomeCombineDataSource가 데이터를 DummyData로 받는 경우
    func customItems() -> ([DummyData]) -> Void {
        let dataSource = CustomCombineDataSource()
        return { (updatedDataList : [DummyData]) in
            // 과정 4: [DummyData]를 dataSource의 pushDataList의 매개변수로 보낸다.
            dataSource.pushDataList(updatedDataList, to: self)
        }
    }
    */
    
    // CustomeCombineDataSource가 데이터를 제네릭으로 받는 경우
    func customItems<T>() -> ([T]) -> Void {
        let dataSource = CustomCombineDataSource<T>()
        return { (updatedDataList : [T]) in
            // 과정 4: [DummyData]를 dataSource의 pushDataList의 매개변수로 보낸다.
            dataSource.pushDataList(updatedDataList, to: self)
        }
    }
    
    func itemsWithCell<T>(makeCell: ((UITableView, IndexPath, T) -> UITableViewCell)? = nil) -> ([T]) -> Void {
        let dataSource = CustomCombineDataSource<T>(makeCell: makeCell)
        return { (updatedDataList : [T]) in
            // 과정 4: [DummyData]를 dataSource의 pushDataList의 매개변수로 보낸다.
            dataSource.pushDataList(updatedDataList, to: self)
        }
    }
}
