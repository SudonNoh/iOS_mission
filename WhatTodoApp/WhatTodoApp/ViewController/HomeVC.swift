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
    
    lazy var pageInfoLbl : UILabel = UILabel().then {
        $0.text = "0"
        $0.textColor = .textPoint
        $0.font = UIFont.boldSystemFont(ofSize: 12)
    }
    
    lazy var todoTableView : UITableView = UITableView().then {
        $0.backgroundColor = .bgColor
    }
    
    lazy var loadingIndicator : UIActivityIndicatorView = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.color = UIColor.systemGray
        $0.startAnimating()
        $0.frame = CGRect(x: 0, y: 0, width: self.todoTableView.bounds.width, height: 44)
    }
    
    lazy var noMoreDataView: UIView = UIView().then {
        $0.frame = CGRect(x: 0, y: 0, width: todoTableView.bounds.width, height: 60)
        $0.backgroundColor = .bgColor

        let label = UILabel().then {
            $0.text = "더 이상 가져올 데이터가 없습니다."
            $0.textColor = .textColor
        }

        $0.addSubview(label)

        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    var viewModel: HomeVM = HomeVM()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.todoTableView.register(TodoCell.self, forCellReuseIdentifier: TodoCell.reuseIdentifire)
        self.todoTableView.delegate = self
        
        self.viewModel
            .isLoading
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _, isLoading in
                self.todoTableView.tableFooterView = isLoading ? self.loadingIndicator : self.noMoreDataView
            })
            .disposed(by: disposeBag)
        
        self.viewModel
            .todoList
            .observe(on: MainScheduler.instance)
            .bind(to: self.todoTableView.rx.items(
                cellIdentifier: TodoCell.reuseIdentifire,
                cellType: TodoCell.self
            )) {[weak self] idx, cellData, cell in
                cell.updateUI(cellData)
            }
            .disposed(by: disposeBag)
        
        self.viewModel
              .errorMsg
              .withUnretained(self)
              .observe(on: MainScheduler.instance)
              .subscribe(onNext: { VC, msg in
                  VC.showErrorAlert(errMsg: msg)
              }).disposed(by: disposeBag)
        
        self.viewModel
            .currentPageInfo
            .observe(on: MainScheduler.instance)
            .bind(to: self.pageInfoLbl.rx.text)
            .disposed(by: disposeBag)
        
        self.todoTableView
            .rx.bottomReached
            .bind(onNext: { self.viewModel.fetchMoreTodos() })
            .disposed(by: disposeBag)
        
        self.viewModel
            .notifyHasNextPage
            .observe(on: MainScheduler.instance)
            .map { !$0 ? self.noMoreDataView : nil }
            .bind(to: self.todoTableView.rx.tableFooterView)
            .disposed(by: disposeBag)
    }
}

// UI Setup
extension HomeVC {
    
    func setup() {
        self.view.backgroundColor = .bgColor
        self.navigationItem.titleView = searchBar
        
        self.view.addSubview(todoTableView)
        self.view.addSubview(pageInfoLbl)
        
        let safeArea = self.view.safeAreaLayoutGuide.snp
        
        pageInfoLbl.snp.makeConstraints {
            $0.top.equalTo(safeArea.top).offset(5)
            $0.centerX.equalTo(safeArea.centerX)
        }
        
        todoTableView.snp.makeConstraints {
            $0.top.equalTo(pageInfoLbl.snp.bottom).offset(10)
            $0.bottom.equalTo(safeArea.bottom).inset(20)
            $0.horizontalEdges.equalTo(safeArea.horizontalEdges).inset(15)
        }
    }
}


extension HomeVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EditVC()
        let eachData = self.viewModel.todoList.value[indexPath.row]
        vc.data = eachData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completeAction = UIContextualAction(style: .normal, title: "Complete") { (_, _, completionHandler) in
            print("완료 액션 !!")
            completionHandler(true)
        }
        completeAction.backgroundColor = .systemGreen
        
        return UISwipeActionsConfiguration(actions: [completeAction])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            print("삭제 액션 !!")
            
            self.showDeleteAlert() {
                completionHandler(true)
            }
            completionHandler(false)
        }
        deleteAction.backgroundColor = .systemRed

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
