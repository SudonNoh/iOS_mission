//
//  ViewController.swift
//  UITableViewTutorial
//
//  Created by Sudon Noh on 2023/05/01.
//

import UIKit

class DefaultListVC: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    
//    var dummyDataList : [DummyData] = DummyData.getDummies()
    var dummyDataList : [DummySection] = DummySection.getDummies()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 데이터 소스 연결
        myTableView.dataSource = self
        myTableView.delegate = self
    }
}

//MARK: - TableViewDelegate 관련
extension DefaultListVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#fileID, #function, #line, "- indexPath : \(indexPath.row)")
    }
}

//MARK: - TableViewDataSource 관련
extension DefaultListVC : UITableViewDataSource {
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
        let cell = UITableViewCell(
            style: .subtitle,
            reuseIdentifier: "MyCell"
        )
        
        // let cellData: DummyData = dummyDataList[indexPath.row]
        
        let sectionData: DummySection = dummyDataList[indexPath.section]
        let cellData = sectionData.rows[indexPath.row]
        
        cell.textLabel?.text = cellData.title
        cell.detailTextLabel?.text = cellData.body
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }
}
