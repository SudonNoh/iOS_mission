//
//  HomeVC.swift
//  WhatTodoApp/ViewController/HomeVC.swift HomeVC().viewDidLoadO()
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
    lazy var orderByBtn : UIButton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrowtriangle.down.square.fill"), for: .normal)
        $0.tintColor = .textColor
    }
    lazy var isDoneBtn : UIStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
        $0.distribution = .fillEqually
        
        $0.addArrangedSubview(showCompletedBtn)
        $0.addArrangedSubview(showNotCompletedBtn)
    }
    lazy var showCompletedBtn : UIButton = UIButton().then {
        $0.setImage(UIImage(systemName: "smallcircle.filled.circle.fill"), for: .normal)
        $0.tintColor = .systemGreen
        $0.tag = 0
    }
    lazy var showNotCompletedBtn : UIButton = UIButton().then {
        $0.setImage(UIImage(systemName: "smallcircle.filled.circle.fill"), for: .normal)
        $0.tintColor = .systemRed
        $0.tag = 1
    }
    var addBtnSize: CGFloat = 60
    lazy var addBtn : UIButton = UIButton().then {
        $0.setBackgroundImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        $0.tintColor = .textPoint
        $0.backgroundColor = .white
        $0.layer.cornerRadius = addBtnSize/2
    }
    
    var isUpdated: Bool = false
    
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
              .subscribe(onNext: { vc, msg in
                  vc.showErrorAlert(errMsg: msg)
                  if msg == "데이터가 없습니다." { self.searchBar.text = "" }
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
        
        self.todoTableView
            .rx
            .willBeginDragging
            .bind { _ in self.addBtn.isHidden = true }
            .disposed(by: disposeBag)
        
        self.todoTableView
            .rx
            .didEndDragging
            .debounce(RxTimeInterval.milliseconds(600), scheduler: MainScheduler.instance)
            .bind { _ in self.addBtn.isHidden = false }
            .disposed(by: disposeBag)
        
        self.addBtn
            .rx
            .tap
            .bind {
                let vc = AddVC()
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        self.viewModel
            .notifyHasNextPage
            .observe(on: MainScheduler.instance)
            .map { !$0 ? self.noMoreDataView : nil }
            .bind(to: self.todoTableView.rx.tableFooterView)
            .disposed(by: disposeBag)
        
        self.orderByBtn.rx.tap
            .bind { self.orderByFucntion() }
            .disposed(by: disposeBag)
        
        self.showCompletedBtn.rx.tap
            .bind {self.isDoneBtnActions(btn: self.showCompletedBtn)}
            .disposed(by: disposeBag)
        
        self.showNotCompletedBtn.rx.tap
            .bind {self.isDoneBtnActions(btn: self.showNotCompletedBtn)}
            .disposed(by: disposeBag)
        
        self.searchBar.searchTextField.rx.text.orEmpty
            .bind(onNext: self.viewModel.searchTerm.accept(_:))
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isUpdated {
            self.viewModel.refreshTodos()
            self.isUpdated = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchBar
                .searchTextField
                .attributedPlaceholder = NSAttributedString(string: "검색어를 입력해주세요.",
                                                            attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        self.searchBar.searchTextField.leftView?.tintColor = .lightGray
    }
}

extension HomeVC {
    
    func setup() {
        self.view.backgroundColor = .bgColor
        self.navigationItem.titleView = searchBar
        
        self.view.addSubview(todoTableView)
        self.view.addSubview(orderByBtn)
        self.view.addSubview(pageInfoLbl)
        self.view.addSubview(isDoneBtn)
        self.view.addSubview(actionIndicator)
        self.view.addSubview(addBtn)
        
        let safeArea = self.view.safeAreaLayoutGuide.snp
        
        pageInfoLbl.snp.makeConstraints {
            $0.top.equalTo(safeArea.top).offset(5)
            $0.centerX.equalTo(safeArea.centerX)
        }
        
        orderByBtn.snp.makeConstraints {
            $0.top.equalTo(pageInfoLbl.snp.top)
            $0.leading.equalTo(safeArea.leading).offset(20)
            $0.trailing.lessThanOrEqualTo(pageInfoLbl.snp.leading)
            $0.bottom.equalTo(pageInfoLbl.snp.bottom)
        }
        
        isDoneBtn.snp.makeConstraints {
            $0.top.equalTo(pageInfoLbl.snp.top)
            $0.leading.greaterThanOrEqualTo(pageInfoLbl.snp.trailing)
            $0.trailing.equalTo(safeArea.trailing).inset(20)
            $0.bottom.equalTo(pageInfoLbl.snp.bottom)
        }

        todoTableView.snp.makeConstraints {
            $0.top.equalTo(pageInfoLbl.snp.bottom).offset(10)
            $0.bottom.equalTo(safeArea.bottom).inset(20)
            $0.horizontalEdges.equalTo(safeArea.horizontalEdges).inset(15)
        }
        
        addBtn.snp.makeConstraints {
            $0.bottom.equalTo(safeArea.bottom).inset(60)
            $0.trailing.equalTo(safeArea.trailing).inset(60)
            $0.width.equalTo(addBtnSize)
            $0.height.equalTo(addBtnSize)
        }
    }
}

// TableView Delegate
extension HomeVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let vc = EditVC()
        let eachData = self.viewModel.todoList.value[indexPath.row]
        vc.data = eachData
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let isDone = self.viewModel.todoList.value[indexPath.row].isDone else { return UISwipeActionsConfiguration() }
        
        let btnTitle = isDone ? "미완료" : "완료"
        
        let completeAction = UIContextualAction(style: .normal, title: btnTitle) { (_, _, completionHandler) in
            
            let comment = isDone ? "미완료 처리 하시겠습니까?" : "완료 처리 하시겠습니까?"
            
            self.showCompleteAlert(message: comment) {
                guard let id = self.viewModel.todoList.value[indexPath.row].id,
                      let title = self.viewModel.todoList.value[indexPath.row].title else {return}
                
                let updatedIsDone: Bool = isDone ? false : true
                
                self.viewModel.updateATodo(id: id, title: title, isDone: updatedIsDone)
            }
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

extension HomeVC {
    func orderByFucntion() {
        
        let arrowStatus = self.viewModel.returnOrderByStatus() == .desc ? "down" : "up"

        self.orderByBtn.rx.image().onNext(UIImage(systemName: "arrowtriangle.\(arrowStatus).square.fill"))
        
        guard let searchText = self.searchBar.text else { return }
        
        self.viewModel.fetchOrSearch(status: searchText.count == 0)
    }
    
    func isDoneBtnActions(btn: UIButton) {
        self.viewModel.isDoneBtnActions(btn: btn)
    }
    
    func statusIcon(status: Bool, btn: UIButton) {
        let string = status ? ".fill":""
        btn.rx.image().onNext(UIImage(systemName: "smallcircle.filled.circle\(string)"))
    }
}

extension HomeVC: SendDataDelegate {
    func refreshList(_ bool: Bool) {
        if bool {
            self.isUpdated = true
        }
    }
}
