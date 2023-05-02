//
//  MyDataSource.swift
//  UITableViewTutorial
//
//  Created by Sudon Noh on 2023/05/01.
//

import Foundation
import UIKit

// MyDataSource 자체를 객체로 만들 예정이기 때문에 NSObject를 상속받는다.
class MyDataSource: NSObject, UITableViewDataSource {
    
    enum ListType {
        case storyboard
        case nib
        case code
        case cellConfig
    }
    
    var listType : ListType = .storyboard
    
    var dummyDataList : [DummySection] = DummySection.getDummies()
    
    override init() {
        super.init()
        print(#fileID, #function, #line, "- ")
    }
    
    convenience init(type: ListType = .storyboard) {
        self.init()
        self.listType = type
        print(#fileID, #function, #line, "- \(type)")
    }
    
    
    /// 셀을 등록
    /// - Parameter tableView: 등록할 테이블 뷰
    func registerCells(with tableView: UITableView) {
        print(#fileID, #function, #line, "- ")
        tableView.register(NibCell.uiNib, forCellReuseIdentifier: NibCell.reuseIdentifier)
        tableView.register(CodeCell.self, forCellReuseIdentifier: CodeCell.reuseIdentifier)
        tableView.register(CellConfigTableViewCell.self, forCellReuseIdentifier: CellConfigTableViewCell.reuseIdentifier)
    }
    
    //MARK: - 테이블뷰 데이터 소스 관련
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Header : " + dummyDataList[section].title
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Footer : " + dummyDataList[section].title
    }
    
    // 섹션의 수
    func numberOfSections(in tableView: UITableView) -> Int {
        dummyDataList.count
    }
    
    // 하나의 섹션에 몇 개의 row가 있는가?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dummyDataList[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //MARK: - guard let 사용
        
        switch listType {
        case .storyboard:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardCell.reuseIdentifier, for: indexPath) as? StoryboardCell else {
                return UITableViewCell()
            }
            
            let sectionData: DummySection = dummyDataList[indexPath.section]
            let cellData = sectionData.rows[indexPath.row]
            
            cell.titleLabel.text = cellData.title
            cell.bodyLabel.text = cellData.body
            return cell
            
        case .nib:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NibCell.reuseIdentifier, for: indexPath) as? NibCell else {
                return UITableViewCell()
            }
            
            let sectionData: DummySection = dummyDataList[indexPath.section]
            let cellData = sectionData.rows[indexPath.row]
            
            cell.titleLabel.text = cellData.title
            cell.bodyLabel.text = cellData.body
            return cell
            
        case .code:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CodeCell.reuseIdentifier, for: indexPath) as? CodeCell else {
                return UITableViewCell()
            }
            
            let sectionData: DummySection = dummyDataList[indexPath.section]
            let cellData = sectionData.rows[indexPath.row]
            
            cell.titleLabel.text = cellData.title
            cell.bodyLabel.text = cellData.body
            return cell
            
        case .cellConfig:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellConfigTableViewCell.reuseIdentifier, for: indexPath) as? CellConfigTableViewCell else {
                return UITableViewCell()
            }
            
            let sectionData: DummySection = dummyDataList[indexPath.section]
            let cellData = sectionData.rows[indexPath.row]
            
            cell.title = cellData.title
            cell.body = cellData.body
            return cell
        }
    }
}
