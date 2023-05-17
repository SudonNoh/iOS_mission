//
//  mainVC.swift
//  TodoAppTutorial
//
//  Created by Sudon Noh on 2023/05/02.
//

import Foundation
import UIKit
import SwiftUI
import RxSwift
import RxRelay
import RxCocoa


class MainVC: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var pageInfoLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var showAddTodoAlertBtn: UIButton!
    @IBOutlet weak var selectedTodosInfoLabel: UILabel!
    @IBOutlet weak var deleteSeletedTodosBtn: UIButton!
    
    // 바텀 인디케이터 뷰
    lazy var bottomIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = UIColor.systemBlue
        indicator.startAnimating()
        indicator.frame = CGRect(x: 0, y: 0, width: myTableView.bounds.width, height: 44)
        return indicator
    }()
    
    // 당겨서 새로고침
    lazy var refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        refreshControl.tintColor = .systemPink
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    // 검색 결과를 찾지 못했을 때의 뷰
    lazy var searchDataNotFoundView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0,
                                        width: myTableView.bounds.width,
                                        height: 300))
        let label = UILabel()
        label.text = "검색결과를 찾을 수 없습니다."
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }()
    
    var searchTermInputWorkItem : DispatchWorkItem? = nil
    
    lazy var bottomNoMoreDataView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0,
                                        width: myTableView.bounds.width,
                                        height: 60))
        let label = UILabel()
        label.text = "더 이상 가져올 데이터가 없습니다."
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }()
    
    var todos : [Todo] = []
    
    var disposeBag = DisposeBag()
    
    //MARK: - MVVM 구현 로직 1
    // 1.앱이 실행되면서 TodosVM() 로직이 실행된다.
    var todosVM: TodosVM_Rx = TodosVM_Rx()
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- ")
        self.view.backgroundColor = .systemYellow
        
        // 버튼 액션 설정
        self.showAddTodoAlertBtn.addTarget(self,
                                           action: #selector(showAddTodoAlert),
                                           for: .touchUpInside)
        
        // 테이블 뷰 설정
        self.myTableView.register(TodoCell.uiNib, forCellReuseIdentifier: TodoCell.reuseIdentifire)
        // self.myTableView.dataSource = self
        
        // self.myTableView.delegate = self
        
        self.myTableView.tableFooterView = bottomIndicator
        self.myTableView.refreshControl = refreshControl
        
        // ===
        
        //MARK: - ScrollView 바닥 이벤트 설정 1
        // 테이블뷰 바닥 이벤트 받기
//        self.myTableView
//            .rx.isNearBottom
//            .debug("❤️ isNearBottom")
//            .subscribe(onNext: { isBottom in
//                if isBottom {
//                    self.todosVM.fetchMore()
//                }
//            })
//            .disposed(by: disposeBag)
        self.myTableView
            .rx.bottomReached
            .debug("❤️ bottomReached")
            .bind(onNext: { self.todosVM.fetchMore() })
            .disposed(by: disposeBag)
        
        // 서치바 설정
        //MARK: - SearchBar rx 설정 1
        // orEmpty를 붙여주면 unwrapping한 데이터를 가지고 올 수 있다.
        searchBar.searchTextField.rx.text.orEmpty
            .debug("❤️ searchTextField")
            //MARK: - SearchBar rx 설정 4
            // 바인드시켜준다
            .bind(onNext: self.todosVM.searchTerm.accept(_:))
            .disposed(by: disposeBag)
        // self.searchBar.searchTextField.addTarget(self, action: #selector(searchTermChanged(_:)), for: .editingChanged)
        
        // ====
        
        // 뷰모델 이벤트 받기 - 뷰 - 뷰모델 바인딩 - 묶기
        // RxDataSource 사용한 방식
        self.todosVM
            .todos
            .bind(to: self.myTableView.rx.items(cellIdentifier: TodoCell.reuseIdentifire, cellType: TodoCell.self)) { [weak self] index, cellData, cell in
                guard let self = self else {return}
                
                cell.updateUI(cellData, self.todosVM.selectedTodoIds)
                cell.onDeleteActionEvent = self.onDeleteItemAction(_:)
                cell.onEditActionEvent = self.onEditItemAction
                cell.onSelectedActionEvent = self.onSelectionItemAction
                
            }.disposed(by: disposeBag)
        
        
        // Rx 방식
//        self.todosVM
//            .todos
//            // [weak self]를 대체
//            .withUnretained(self)
//            // 메인 쓰레드에서 실행
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { mainVC, updatedTodos in
//                mainVC.todos = updatedTodos
//                mainVC.myTableView.reloadData()
//            }).disposed(by: disposeBag)
        
        //MARK: - MVVM 구현 로직 6
        // 6.데이터를 updatedTodos로 받아서 self.todos에 넣어준다.
        // 그 다음 reloadData를 해주면 tableView(:,numberOfRowsInSection) -> tableView(:,cellForRowAt) 이 차례로 동작한다.
        // Closure
//        self.todosVM.notifyTodosChanged = { [weak self] updatedTodos in
//            guard let self = self else {return}
//            self.todos = updatedTodos
//            DispatchQueue.main.async {
//                self.myTableView.reloadData()
//            }
//        }
        
        // 다음페이지 존재 여부
        //MARK: - pageInfo rx로 구현 3
        self.todosVM
            .notifyHasNextPage
            .observe(on: MainScheduler.instance)
            .map { !$0 ? self.bottomNoMoreDataView : nil } // Observable<UIView>? // $0은 hasNext
            .bind(to: self.myTableView.rx.tableFooterView)
            .disposed(by: disposeBag)
        
//        self.todosVM.notifyHasNextPage = {[weak self] hasNext in
//            guard let self = self else {return}
//            DispatchQueue.main.async {
//                self.myTableView.tableFooterView = !hasNext ? self.bottomNoMoreDataView : nil
//            }
//        }
        
        // 페이지 변경 이벤트
        //MARK: - currentPage rx 구현 3
        self.todosVM
        // 아래 주석처리 된 부분을 뷰 모델에서 처리하고 싶다! 그러면 currentPage rx 구현 4로 이동
//            .currentPage
//            .map { "MainVC / page: \($0)" }
        //MARK: - currentPage rx 구현 6
        // currentPageInfo를 받는다.
            .currentPageInfo
            .observe(on: MainScheduler.instance)
            .bind(to: self.pageInfoLabel.rx.text)
            .disposed(by: disposeBag)
        
//        self.todosVM.notifyCurrentPageChanged = { [weak self] currentPage in
//            guard let self = self else {return}
//            DispatchQueue.main.async {
//                self.pageInfoLabel.text = "MainVC / page: \(currentPage)"
//            }
//        }
        
        self.todosVM.notifyLoadingStateChanged = { [weak self] isLoading in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.myTableView.tableFooterView = isLoading ? self.bottomIndicator : nil
            }
        }
        
        // 당겨서 새로고침 완료
        self.todosVM.notifyRefreshEnded = { [weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
        
        // 데이터가 없는 경우에 발생하는 이벤트
        self.todosVM.notifySearchDataNotFound = {[weak self] notFound in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.myTableView.backgroundView = notFound ? self.searchDataNotFoundView : nil
            }
        }
        
        // 할 일 추가 완료 이벤트
        self.todosVM.notifyTodoAdded = {[weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.myTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
        
        // 에러가 발생했을 때
        self.todosVM.notifyErrorOccured = {[weak self] errMsg in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.showErrorAlert(errMsg: errMsg)
            }
        }
        
        self.todosVM.notifySeletedTodoIdsChanged = {[weak self] seletedTodoIds in
            guard let self = self else {return}
            DispatchQueue.main.async {
                let idsInfoString = seletedTodoIds.map { "\($0)"}.joined(separator: ", ")
                self.selectedTodosInfoLabel.text = "선택된 할 일: [ " + idsInfoString + " ]"
            }
        }
        
        self.deleteSeletedTodosBtn.addTarget(self, action: #selector(onDeleteSeletedTodosBtnClicked(_:)), for: .touchUpInside)
        
        // ====
        
    } // viewDidLoad
}

//MARK: - Alert
extension MainVC {
    
    // 수정
    @objc fileprivate func showEditTodoAlert(_ id: Int, _ existingTitle: String){
        let alert = UIAlertController(title: "수정", message: "\(id)", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "예) 빡코딩하기"
            textField.text = existingTitle
        }
        
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: { [weak alert] (_) in
            if let userInput = alert?.textFields?[0].text {
                self.todosVM.editATodo(id, userInput)
            }
        })
        
        let closeAction = UIAlertAction(title: "닫기", style: .destructive)
        
        alert.addAction(confirmAction)
        alert.addAction(closeAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // 삭제
    @objc fileprivate func showDeleteTodoAlert(_ id: Int){
        let alert = UIAlertController(title: "할일 삭제", message: "id:\(id) 할 일을 삭제하시겠습니까?", preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.todosVM.deleteATodo(id)
        })
        
        let closeAction = UIAlertAction(title: "닫기", style: .cancel)
        
        alert.addAction(submitAction)
        alert.addAction(closeAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // 추가
    @objc fileprivate func showAddTodoAlert(){
        let alert = UIAlertController(title: "추가", message: "할 일을 입력해주세요.", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "예) 빡코딩하기"
        }
        
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: { [weak alert] (_) in
            if let userInput = alert?.textFields?[0].text {
                self.todosVM.addATodo(userInput)
            }
        })
        
        let closeAction = UIAlertAction(title: "닫기", style: .destructive)
        
        alert.addAction(confirmAction)
        alert.addAction(closeAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // 에러
    @objc fileprivate func showErrorAlert(errMsg: String){
        let alert = UIAlertController(title: "안내", message: errMsg, preferredStyle: .alert)
        
        let closeAction = UIAlertAction(title: "닫기", style: .cancel)
        
        alert.addAction(closeAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}


//MARK: - Actions
extension MainVC {
//    @objc fileprivate func searchTermChanged(_ sender: UITextField) {
//
//        // 검색어가 입력되면 기존 작업 취소
//        searchTermInputWorkItem?.cancel()
//
//        let dispatchWrokItem = DispatchWorkItem(block: {
//            // 백그라운드 - 사용자 입력 userInteractive
//            DispatchQueue.global(qos: .userInteractive).async {
//                DispatchQueue.main.async { [weak self] in
//                    guard let userInput = sender.text,
//                          let self = self else {return}
//
//                    // 검색어를 모두 지웠을 때 다시 한번 갱신시킨다.
//                    // Closure
//                    // self.todosVM.todos = []
//                    // Rx
//                    self.todosVM.todos.accept([])
//
//                    // 뷰모델 검색어 갱신
//                    print(#fileID, #function, #line, "- \(userInput)")
//                    self.todosVM.searchTerm = userInput
//                }
//            }
//        })
//
//        // 기존 작업을 취소하기 위해서 메모리 주소를 일치시켜주었다.
//        self.searchTermInputWorkItem = dispatchWrokItem
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: dispatchWrokItem)
//    }
    
    @objc fileprivate func handleRefresh(_ sender: UIRefreshControl) {
        // 뷰모델에서 실행하기
        self.todosVM.fetchRefresh()
    }
    
    @objc fileprivate func onDeleteSeletedTodosBtnClicked(_ sender: UIButton) {
        print(#fileID, #function, #line, "- ")
        self.todosVM.deleteSeletedTodos()
    }
    
    /// 셀의 삭제 버튼 클릭시 , 방법 2
    /// - Parameter id: 삭제할 아이템
    fileprivate func onDeleteItemAction(_ id: Int) {
        print(#fileID, #function, #line, "- id : \(id)")
        self.showDeleteTodoAlert(id)
    }
    
    
    /// 셀의 수정 버튼 클릭시
    /// - Parameters:
    ///   - id: 수정 할 아이템 id
    ///   - title: 수정 내용
    fileprivate func onEditItemAction(_ id: Int, _ title: String) {
        self.showEditTodoAlert(id, title)
    }
    
    /// 셀의 아이템 선택 이벤트
    /// - Parameters:
    ///   - id: 아이디
    ///   - isOn: 선택여부
    fileprivate func onSelectionItemAction(_ id: Int, _ isOn: Bool) {
        self.todosVM.handleTodoSelection(selectedTodoId: id, isOn: isOn)
    }
}


extension MainVC : UITableViewDelegate {
    
    /// ScrollView Scroll Event
    /// - Parameter scrollView:
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(#fileID, #function, #line, "- ")
//        let height = scrollView.frame.size.height
//        let contentYOffset = scrollView.contentOffset.y
//        let distanceFromBottom = scrollView.contentSize.height - contentYOffset
//
//        if distanceFromBottom - 200 < height {
//            print("You reached end of the table !")
//            self.todosVM.fetchMore()
//        }
//    }
}


// 데이터의 수 설정, 셀 설정
/*
extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return todos.count
        // 위를 아래와 같이 바꿔도 무관하다.
        // return todosVM.todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.reuseIdentifire, for: indexPath) as? TodoCell else {
            return UITableViewCell()
        }

        let cellData = self.todos[indexPath.row]
        // Cell에 데이터 넣어주기
        cell.updateUI(cellData, self.todosVM.selectedTodoIds)
        
        // 방법 1.
        // cell.onDeleteActionEvent = { self.showDeleteTodoAlert($0) }
        
        // 방법 2.
        cell.onDeleteActionEvent = onDeleteItemAction(_:)
        
        cell.onEditActionEvent = onEditItemAction
        cell.onSelectedActionEvent = onSelectionItemAction
        
        
        return cell
    }
}
*/

// 아래 과정은 UIKit로 만든 Storyboard를 SwiftUI로 보기 가져가기 위한 로직이다.
// SwiftUI View
extension MainVC {
    private struct VCRepresentable : UIViewControllerRepresentable {
        
        let mainVC : MainVC
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return mainVC
        }
    }
    
    func getRepresentable() -> some View {
        VCRepresentable(mainVC: self)
    }
}

