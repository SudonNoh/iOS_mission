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
        self.todoTableView.register(TodoCell.self, forCellReuseIdentifier: TodoCell.reuseIdentifire)
        
        self.VM
            .todoList
            .bind(to: self.todoTableView.rx.items(
                cellIdentifier: TodoCell.reuseIdentifire,
                cellType: TodoCell.self
            )) {[weak self] idx, cellData, cell in
                cell.updateUI(cellData)
            }
            .disposed(by: disposeBag)
        
        self.todoTableView
            .rx
            .estimatedRowHeight
            .onNext(UITableView.automaticDimension)
        
        self.todoTableView
            .rx
            .itemSelected
            .subscribe(onNext: { idx in
                print("클릭되었다. \(idx)")
            }).disposed(by: disposeBag)
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


//extension HomeVC: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(#fileID, #function, #line, "- \(indexPath.row + 1) 번째 행이 클릭되었습니다. !")
//    }
//
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (action, view, completionHandler) in
//            self.dataSource.remove(at: indexPath.row)
//            self.todoTableView.deleteRows(at: [indexPath], with: .automatic)
//            completionHandler(true)
//        }
//        deleteAction.backgroundColor = .red
//
//        return UISwipeActionsConfiguration(actions: [deleteAction])
//    }
//}
