//
//  StoryboardListVC.swift
//  UITableViewTutorial
//
//  Created by Sudon Noh on 2023/05/01.
//

import Foundation
import UIKit

// 데이터 소스 사용 전
/*
class StoryboardListVC : UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    
    var dummyDataList : [DummySection] = DummySection.getDummies()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- StoryboardListVC")
        
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
    }
}


//MARK: - TableViewDelegate 관련
extension StoryboardListVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#fileID, #function, #line, "- indexPath : \(indexPath.row)")
    }
}

//MARK: - TableViewDataSource 관련
extension StoryboardListVC : UITableViewDataSource {
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
        // dummyData
        // dummyDataList.count
        // dummyDataSection
        dummyDataList[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //MARK: - if let 사용
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "StoryboardCell", for: indexPath) as? StoryboardCell {
//
//            let sectionData: DummySection = dummyDataList[indexPath.section]
//            let cellData = sectionData.rows[indexPath.row]
//
//            cell.titleLable.text = cellData.title
//            cell.bodyLable.text = cellData.body
//            return cell
//        } else {
//            return UITableViewCell()
//        }
        
        //MARK: - guard let 사용
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardCell.reuseIdentifier, for: indexPath) as? StoryboardCell else {
            return UITableViewCell()
        }
            
        let sectionData: DummySection = dummyDataList[indexPath.section]
        let cellData = sectionData.rows[indexPath.row]
        
        cell.titleLable.text = cellData.title
        cell.bodyLable.text = cellData.body
        return cell
    }
}
*/

// 데이터 소스 사용 후(MyDataSource.swift)
class StoryboardListVC : UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    
    var dataSource : MyDataSource = MyDataSource(type: .storyboard)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- StoryboardListVC")
        
        self.myTableView.dataSource = dataSource
        self.myTableView.delegate = self
    }
}

//MARK: - TableViewDelegate 관련
extension StoryboardListVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#fileID, #function, #line, "- indexPath : \(indexPath.row)")
    }
}
