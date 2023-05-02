//
//  NibListVC.swift
//  UITableViewTutorial
//
//  Created by Sudon Noh on 2023/05/01.
//

import Foundation
import UIKit

class NibListVC : UIViewController {
    
    // MyDataSource 사용 전
    // var dummyDataList : [DummySection] = DummySection.getDummies()
    
    var dataSource: MyDataSource = MyDataSource(type: .nib)
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        print(#fileID, #function, #line, "- MainVC")
    }
    
    fileprivate func configureTableView(){
        
        // Nib 파일 등록
        // let cellNib = UINib(nibName: "NibCell", bundle: nil)
        
        // cellNib을 Protocol로 대체
        // self.myTableView.register(NibCell.uiNib, forCellReuseIdentifier: NibCell.reuseIdentifier)
        
        // 셀 등록 변경
        self.dataSource.registerCells(with: self.myTableView)
        
        // self.myTableView.dataSource = self
        self.myTableView.dataSource = dataSource
        self.myTableView.delegate = self
    }
}


//MARK: - TableViewDelegate 관련
extension NibListVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#fileID, #function, #line, "- indexPath : \(indexPath.row)")
    }
}

// MyDataSource 사용 전
/*
//MARK: - TableViewDataSource 관련
extension NibListVC : UITableViewDataSource {
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NibCell", for: indexPath) as? NibCell else {
            return UITableViewCell()
        }
            
        let sectionData: DummySection = dummyDataList[indexPath.section]
        let cellData = sectionData.rows[indexPath.row]
        
        cell.titleLabel.text = cellData.title
        cell.bodyLabel.text = cellData.body
        return cell
    }
}
*/
