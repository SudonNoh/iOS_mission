//
//  CodeListVC.swift
//  UITableViewTutorial
//
//  Created by Sudon Noh on 2023/05/01.
//

import Foundation
import UIKit
import Combine

class CombineListVC : UIViewController {
    
    // var dummyDataList : [DummySection] = DummySection.getDummies()
    var dataSource : MyDataSource = MyDataSource(type: .code)
    
    @IBOutlet weak var myTableView: UITableView!
    
    var subscriptions = Set<AnyCancellable>()
    
    // @Published var dummies : [DummyData] = []
    @Published var dummies : [MyData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
//        $dummies
//            .receive(on: DispatchQueue.main)
//            .sink(receiveValue: { (changedDummies : [DummyData]) in
//                print(#fileID, #function, #line, "- \(changedDummies.count)")
//                // 위에서 receive로 스레드를 main으로 지정하면 아래와 같이 할 필요가 없다.
//                // DispatchQueue.main.async {
//                //     self.myTableView.reloadData()
//                // }
//                self.myTableView.reloadData()
//            })
//            .store(in: &subscriptions)
        
        // 과정 2: 추가된 데이터를 customItems로 보낸다.
        // $dummies
        //     .receive(on: DispatchQueue.main)
        //     .sink(receiveValue: self.myTableView.customItems())
        //     .store(in: &subscriptions)
        
        $dummies
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: self.myTableView.itemsWithCell(
                makeCell: { tableView, indexPath, cellData in
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: CodeCell.reuseIdentifier, for: indexPath) as? CodeCell else {
                        return UITableViewCell()
                    }
                    cell.titleLabel.text = cellData.title
                    cell.bodyLabel.text = cellData.body
                    
                    return cell
                })
            )
            .store(in: &subscriptions)
        
        
        // 과정 1: 버튼을 누르면 2초 뒤에 dummies에 데이터가 추가된다.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            // self.dummies += DummyData.getDummies(10)
            self.dummies += MyData.getDummies(10)
            
        })
    }
    
    fileprivate func configureTableView(){

        self.myTableView.register(CodeCell.self, forCellReuseIdentifier: CodeCell.reuseIdentifier)
        
        // self.myTableView.dataSource = self
        // self.myTableView.delegate = self
    }
}

//extension CombineListVC : UITableViewDataSource {
//
//    // 하나의 섹션에 몇 개의 row가 있는가?
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        self.dummies.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: CodeCell.reuseIdentifier, for: indexPath) as? CodeCell else {
//            return UITableViewCell()
//        }
//
//        let cellData = self.dummies[indexPath.row]
//
//        cell.titleLabel.text = cellData.title
//        cell.bodyLabel.text = cellData.body
//        return cell
//    }
//}

//MARK: - TableViewDelegate 관련
//extension CombineListVC : UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(#fileID, #function, #line, "- indexPath : \(indexPath.row)")
//    }
//}
