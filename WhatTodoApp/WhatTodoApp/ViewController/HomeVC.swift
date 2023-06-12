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
    
    // mount.fill - asc / desc
    // smallcircle.filled.circle -
    // smallcircle.filled.circle.fill
    
    lazy var bottomIndicator : UIActivityIndicatorView = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.color = UIColor.systemGray
        $0.startAnimating()
        $0.frame = CGRect(x: 0, y: 0, width: self.todoTableView.bounds.width, height: 44)
    }
    
    lazy var actionIndicator : UIActivityIndicatorView = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.color = UIColor.systemGray
        $0.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        $0.center = self.view.center
        $0.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.searchBar
                .searchTextField
                .attributedPlaceholder = NSAttributedString(string: "검색어를 입력해주세요.",
                                                            attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        self.searchBar.searchTextField.leftView?.tintColor = .lightGray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.todoTableView.register(TodoCell.self, forCellReuseIdentifier: TodoCell.reuseIdentifire)
        self.todoTableView.delegate = self

        self.viewModel
            .isLoadingBottom
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _, isLoadingBottom in
                self.todoTableView.tableFooterView = isLoadingBottom ? self.bottomIndicator : nil
            })
            .disposed(by: disposeBag)
        
        self.viewModel
            .isLoadingAction
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _, isLoadingAction in
                isLoadingAction ? self.actionIndicator.startAnimating() : self.actionIndicator.stopAnimating()
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
        self.view.addSubview(actionIndicator)
        
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
        
        guard let isDone = self.viewModel.todoList.value[indexPath.row].isDone else { return UISwipeActionsConfiguration() }
        
        let btnTitle = isDone ? "미완료" : "완료"
        
        let completeAction = UIContextualAction(style: .normal, title: btnTitle) { (_, _, completionHandler) in
            
            guard let id = self.viewModel.todoList.value[indexPath.row].id,
                  let title = self.viewModel.todoList.value[indexPath.row].title else {return}
            
            let updatedIsDone: Bool = isDone ? false : true
            
            self.viewModel.updateATodo(id: id, title: title, isDone: updatedIsDone)
            
            completionHandler(true)
        }
        completeAction.backgroundColor = isDone ? .systemRed : .systemGreen
        
        return UISwipeActionsConfiguration(actions: [completeAction])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (action, view, completionHandler) in
            
            guard let id = self.viewModel.todoList.value[indexPath.row].id else {return}
            
            self.showDeleteAlert() {
                self.viewModel.deleteATodo(id: id)
            }
            
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
