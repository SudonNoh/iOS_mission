//
//  CellConfigurationListVC.swift
//  UITableViewTutorial
//
//  Created by Sudon Noh on 2023/05/01.
//

import Foundation
import UIKit

class CellConfigurationListVC : UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    
    // var dummyDataList : [DummySection] = DummySection.getDummies()
    var dataSource : MyDataSource = MyDataSource(type: .cellConfig)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- CellConfigurationListVC")
        
        configureTableView()
    }
    
    fileprivate func configureTableView(){
        
        // self.myTableView.register(CellConfigTableViewCell.self, forCellReuseIdentifier: CellConfigTableViewCell.reuseIdentifier)
        
        self.dataSource.registerCells(with: self.myTableView)
        
        self.myTableView.dataSource = dataSource
        self.myTableView.delegate = self
    }
}

//MARK: - TableViewDelegate 관련
extension CellConfigurationListVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#fileID, #function, #line, "- indexPath : \(indexPath.row)")
    }
}

/*
//MARK: - TableViewDataSource 관련
extension CellConfigurationListVC : UITableViewDataSource {
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
        
        //MARK: - guard let 사용
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
*/
