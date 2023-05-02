//
//  CustomCombineDataSource.swift
//  UITableViewTutorial
//
//  Created by Sudon Noh on 2023/05/01.
//

import Foundation
import UIKit


// 제네릭:
class CustomCombineDataSource<T>: NSObject, UITableViewDataSource {
    
    // 함수를 클로저로 만드는 방법
    // 셀을 보여주는 부분을 클로저로 작성
    // @escaping을 써줘야 하는 경우
    // let makeCell : (_ tableView: UITableView, _ IndexPath: IndexPath, _ cellData: T) -> UITableViewCell
    // optional로 받아서 @escaping을 쓰지 않아도 되는 경우
    var makeCell : ((UITableView, IndexPath, T) -> UITableViewCell)? = nil
    
    var dataList : [T] = []
    
    // 셀을 보여주는 부분을 클로저로 사용할 때는 초기값을 받아주어야 한다.
    // @escaping을 써줘야 하는 경우
    // init(makeCell: @escaping (_ tableView: UITableView, _ IndexPath: IndexPath, _ cellData: T) -> UITableViewCell) {
    //     self.makeCell = makeCell
    //     super.init()
    // }
    
    init(makeCell: ((_ tableView: UITableView, _ IndexPath: IndexPath, _ cellData: T) -> UITableViewCell)? = nil) {
        self.makeCell = makeCell
        super.init()
    }
    
    // 셀을 보여주는 부분을 클로저로 사용하지 않을 때
    // override init() {
    //     super.init()
    //     print(#fileID, #function, #line, "- ")
    // }
    
    // 변경된 데이터를 받아서 테이블뷰에 적용한다.
    func pushDataList(_ updatedDataList: [T], to tableView: UITableView) {
        print(#fileID, #function, #line, "- ")
        tableView.dataSource = self
        // 과정 5: 받은 [DummyData]를 CustomCombineDataSource에 정의된 self.dataList에 넣어준다.
        // combine 로직을 통해 들어온 데이터를 현재 가지고 있는 데이터에 업데이트 시켜준다.
        self.dataList = updatedDataList
        // 과정 6: 아래 테이블뷰 데이터 소스 프로토콜을 따라 reload 된다.
        tableView.reloadData()
    }
    
    // 하나의 섹션에 몇 개의 row가 있는가?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataList.count
    }
    
    // 어떤 셀을 보여줄지 정하는 부분
    // 1. TableView
    // 2. indexPath : 몇 번째인지
    // 3. Cell에 대한 데이터 - 셀에 대한 제네릭 데이터
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // makeCell 클로저 사용하는 경우
        // makeCell(tableView, indexPath, dataList[indexPath.row])
        
        // Optional 설정
        makeCell?(tableView, indexPath, dataList[indexPath.row]) ?? UITableViewCell()
        
        // 테이블뷰에 셀을 가져오는 과정
        /* // makeCell 클로저 사용하지 않는 경우
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CodeCell.reuseIdentifier, for: indexPath) as? CodeCell else {
            return UITableViewCell()
        }

        if let dataList = dataList as? [DummyData] {
            let cellData : DummyData = dataList[indexPath.row]

            cell.titleLabel.text = cellData.title
            cell.bodyLabel.text = cellData.body
        }
        
        if let dataList = dataList as? [MyData] {
            let cellData : MyData = dataList[indexPath.row]

            cell.titleLabel.text = cellData.title
            cell.bodyLabel.text = cellData.body
        }
        
        return cell
        */
    }
}
