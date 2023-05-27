//
//  HomeVC.swift
//  WhatTodoApp
//
//  Created by Sudon Noh on 2023/05/18.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then


class HomeVC: CustomVC {
    
    lazy var searchBar : UISearchBar = UISearchBar().then {
        $0.placeholder = "검색어를 입력해주세요."
        $0.searchTextField.textColor = .searchBarTextColor
        $0.searchTextField.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        $0.searchTextField.backgroundColor = .textColor
        $0.layer.shadowColor = UIColor.lightGray.cgColor
        $0.layer.shadowOffset = CGSize(width: 0.7, height: 5.0)
        $0.layer.shadowRadius = 5.0
        $0.layer.shadowOpacity = 3.0
    }
    
    lazy var todoTableView : UITableView = UITableView().then {
        $0.backgroundColor = .bgColor
    }
    
    var dataSource: [DummyData] = DummyData.getDummies()
    
    var VM: HomeVM = HomeVM()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.todoTableView.register(TodoCell.self, forCellReuseIdentifier: "TodoCell")
        
        self.VM
            .todoList
            .bind(to: self.todoTableView.rx.items(
                cellIdentifier: "TodoCell",
                cellType: TodoCell.self
            )) {[weak self] idx, cellData, cell in
                cell.updateUI(cellData)
            }
            .disposed(by: disposeBag)
    }
}

// UI Setup
extension HomeVC {
    
    func setup() {
        self.view.backgroundColor = .bgColor
        self.navigationItem.titleView = searchBar
        
        self.view.addSubview(todoTableView)
        
        todoTableView.snp.makeConstraints {
            $0.verticalEdges.equalTo(self.view.safeAreaLayoutGuide.snp.verticalEdges).inset(20)
            $0.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide.snp.horizontalEdges).inset(15)
        }
    }
}

extension HomeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as? TodoCell else {
            print(#fileID, #function, #line, "- 오류로 진입")
            return UITableViewCell()
        }
        
        let cellData = dataSource[indexPath.row]
        
        cell.titleLabel.numberOfLines = 0
        cell.titleLabel.text = cellData.title
        cell.updatedDateLabel.text = "Update : " + cellData.updateDate
        cell.createdDateLabel.text = "Create : " + cellData.createDate
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.textPoint?.cgColor
        cell.layer.cornerRadius = 4
        
        return cell
    }
}

extension HomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#fileID, #function, #line, "- \(indexPath.row + 1) 번째 행이 클릭되었습니다. !")
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (action, view, completionHandler) in
            self.dataSource.remove(at: indexPath.row)
            self.todoTableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

#if DEBUG
import SwiftUI

struct HomeVCPreView: PreviewProvider {
    static var previews: some View {
        HomeVC().toPreview().ignoresSafeArea()
    }
}
#endif
