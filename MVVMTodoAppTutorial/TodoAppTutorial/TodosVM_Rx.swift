//
//  TodosVM.swift
//  TodoAppTutorial
//
//  Created by Sudon Noh on 2023/05/02.
//

import Foundation
import RxSwift
import RxRelay


class TodosVM_Rx {
    
    // 1. Observable - 자동으로 한번 발송하고 끝
    // 2. BehaviorRelay - .value 로 접근 .value로 마지막으로 보낸 데이터를 알 수 있다.
    // 3. PublishRelay - 이벤트를 한 번 보낼 수 있는 기능
    
    var disposeBag = DisposeBag()
    
    // 가공된 최종 데이터
    var todos : BehaviorRelay<[Todo]> = BehaviorRelay<[Todo]>(value: [])
    
    
    
    // 선택된 할일 목록
    var selectedTodoIds: Set<Int> = [] {
        didSet {
            print(#fileID, #function, #line, "- selectedTodoIds: \(selectedTodoIds)")
            self.notifySeletedTodoIdsChanged?(Array(selectedTodoIds))
        }
    }
    
    //MARK: - pageInfo rx로 구현 1
    var pageInfo : BehaviorRelay<Meta?> = BehaviorRelay<Meta?>(value: nil)
    var notifyHasNextPage : Observable<Bool>
    
    // 페이지 정보
//    var pageInfo : Meta? = nil {
//        didSet {
//            // 다음페이지 있는지 여부 이벤트 보내기
//            self.notifyHasNextPage?( pageInfo?.hasNext() ?? true)
//
//            // 현재 페이지 변경 이벤트
//            self.notifyCurrentPageChanged?(currentPage)
//        }
//    }
    
    // 현재 페이지
    //MARK: - currentPage rx 구현 1
    var currentPage : BehaviorRelay<Int> = BehaviorRelay<Int>(value: 1)
    //MARK: - currentPage rx 구현 4
    var currentPageInfo : Observable<String>
    
//    var currentPage : Int {
//        get {
//            if let pageInfo = self.pageInfo.value,
//               let currentPage = pageInfo.currentPage {
//                return currentPage
//            } else {
//                return 1
//            }
//        }
//    }
    
    // 로딩 여부 변경 이벤트
    var isLoading : Bool = false {
        didSet{
            self.notifyLoadingStateChanged?(isLoading)
        }
    }
    
    // 리프레시 완료 이벤트
    var notifyRefreshEnded : (()->Void)? = nil
    
    /// 검색어
    //MARK: - SearchBar rx 설정 2
    var searchTerm: BehaviorRelay<String> = BehaviorRelay<String>(value:"")
    
//    var searchTerm: String = "" {
//        didSet {
//            if searchTerm.count > 0 {
//                self.searchTodos(searchTerm: searchTerm)
//            } else {
//                self.fetchTodos()
//            }
//        }
//    }
    
    // 검색결과 없음 여부 이벤트
    var notifySearchDataNotFound: ((_ noContent: Bool)->Void)? = nil
    
//    var notifyHasNextPage: ((_ hasNext: Bool)->Void)? = nil
    
//    var notifyCurrentPageChanged : ((Int) -> Void)? = nil
    
    var notifyLoadingStateChanged : ((_ isLoading: Bool) -> Void)? = nil
    
    // 할 일 추가 완료 이벤트
    var notifyTodoAdded : (() -> Void)? = nil
    
    // 에러 발생 이벤트
    var notifyErrorOccured : ((_ errMsg: String) -> Void)? = nil
    
    // 선택된 할 일들 변경 이벤트
    var notifySeletedTodoIdsChanged: ((_ selectedIds: [Int]) -> Void)? = nil

    init() {
        
        //MARK: - currentPage rx 구현 5
        currentPageInfo = self.currentPage.map { "MainVC / page: \($0)" }
        
        //MARK: - currentPage rx 구현 2
        // pageInfo가 변경이 되면 그거에 따라 구독처리가 되었기 때문에
        // currentPage의 값을 자동으로 변경
        pageInfo
            .compactMap{ $0 } // Meta
            .map { // 형 변환
                if let currentPage = $0.currentPage {
                    return currentPage
                } else {
                    return 1
                }
            }
            .bind(onNext: self.currentPage.accept(_:))
            .disposed(by: disposeBag)
        
        //MARK: - pageInfo rx로 구현 2
        // skip(1) <- 첫 번째 들어오는 값은 넘어가고, 두 번째 들어오는 값부터 받는다.
        // skip을 하지 않았을 때, 첫 화면에서 로딩 모션이 안보인다.
        self.notifyHasNextPage = pageInfo.skip(1).map { $0?.hasNext() ?? true} // Observable<Bool>
        
        //MARK: - SearchBar rx 설정 3
        searchTerm
            //MARK: - SearchBar rx 설정 4
            //withUnretained를 사용해서 [weak self]를 처리하고 구독하는 부분에서 self를 vm으로 받는다.
            .withUnretained(self)
//            .do(onNext: { _ in
//                print(#fileID, #function, #line, "- 초기화")
//                self.todos.accept([])
//            })
            .debounce(RxTimeInterval.milliseconds(700), scheduler: MainScheduler.instance)
            .debug("❤️ VM - searchTerm")
            .subscribe(onNext: { vm, searchterm in
                if searchterm.count > 0 {
                    // 페이지 정보를 nil 처리를 한 번 하고,
                    // 현재 페이지를 1로 초기화 시켜주자.
                    self.pageInfo.accept(nil)
                    self.currentPage.accept(1)
                    vm.searchTodos(searchTerm: searchterm)
                } else {
                    vm.fetchTodos()
                }
            }).disposed(by: disposeBag)
        
        //MARK: - MVVM 구현 로직 2
        // 2.TodosVM() 로직이 실행되면서 init() 부분이 동작하고 fetchTodos() 함수가 실행된다.
        // fetchTodos()
    }
    
    /// 선택된 할 일 처리
    /// - Parameters:
    ///   - selectedTodoId:
    ///   - isOn:
    func handleTodoSelection(selectedTodoId: Int, isOn: Bool) {
        if isOn {
            self.selectedTodoIds.insert(selectedTodoId)
        } else {
            self.selectedTodoIds.remove(selectedTodoId)
        }
    }
    
    // 데이터 리프레쉬
    func fetchRefresh() {
        self.fetchTodos(page: 1)
    }
    
    // 더 가져오기
    func fetchMore(){
        print(#fileID, #function, #line, "- ")
        
        guard let pageInfo = self.pageInfo.value,
              pageInfo.hasNext(),
              !isLoading else {
            return print("다음 페이지가 없습니다.")
        }
        
        if searchTerm.value.count > 0 {
            // 검색어가 있는 경우
            self.searchTodos(searchTerm: searchTerm.value, page: self.currentPage.value + 1)
        } else {
            self.fetchTodos(page: currentPage.value + 1)
        }
    }
    
    /// 할 일 추가
    /// - Parameter title: 제목
    func addATodo(_ title: String) {
        
        if isLoading {
            print("로딩 중 입니다.")
            return
        }
        
        self.isLoading = true

        //  현재 상태에서는 handleError 메소드를 통해 일괄적으로 에러 메세지를 처리했지만
        //  아래와 같이 할 일 추가에서 직접적으로 처리할 수 있다.
        //  if title.isEmpty {
        //     self.notifyErrorOccured?("")
        //     return
        //  }
        
        TodosAPI.addTodoAndFetchTodos(title: title,
                                      completion: {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.isLoading = false
                if let fetchedTodos: [Todo] = response.data,
                   let pageInfo: Meta = response.meta {
                    self.todos.accept(fetchedTodos)
                    self.pageInfo.accept(pageInfo)
                    self.notifyTodoAdded?()
                }
            case .failure(let failure):
                self.isLoading = false
                self.handleError(failure)
            }
        })
    }
    
    /// 할 일 검색하기
    /// - Parameters:
    ///   - searchTerm: 검색어
    ///   - page: 검색 페이지
    func searchTodos(searchTerm: String, page: Int = 1) {
        
        if searchTerm.count < 1 {
            print("검색어가 업습니다.")
            return
        }
        
        if isLoading {
            print("로딩 중입니다.")
            return
        }
        
        guard pageInfo.value?.hasNext() ?? true else {
            return print("다음 페이지 없음")
        }
        
        self.notifySearchDataNotFound?(false)
        
        // 현재 페이지가 1일 때만
        if page == 1 {
            self.todos.accept([])
        }

        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.7, execute: {
            TodosAPI.searchTodos(searchTerm: searchTerm,
                                 page:page,
                                 completion: { [weak self] result in
                guard let self = self else { return }
                print(#fileID, #function, #line, "- \(result)")
                switch result {
                case .success(let response):
                    
                    self.isLoading = false
                    
                    if let fetchedTodos = response.data,
                       let pageInfo : Meta = response.meta{
                        
                        if page == 1 {
                            self.todos.accept(fetchedTodos)
                        } else {
                            
                            let addedTodos = self.todos.value + fetchedTodos
                            self.todos.accept(addedTodos)
                        }
                        
                        self.pageInfo.accept(pageInfo)
                    }
                    
                case .failure(let failure):
                    self.handleError(failure)
                    self.isLoading = false
                }
                self.notifyRefreshEnded?()
            })
        })
    }
    
    /// 할 일 가져오기
    /// - Parameter page: page
    func fetchTodos(page: Int = 1) {
        
        if isLoading {
            print("로딩 중입니다.")
            return
        }
        
        isLoading = true
        
        // 딜레이를 주기 위한 방법
        Observable.just(())
            .delay(RxTimeInterval.milliseconds(700), scheduler: MainScheduler.instance)
            .flatMapLatest {
                TodosAPI
                    .fetchTodosWithObservable(page:page)
            }
            // 이벤트 완료시 실행
            .do(onError: { err in
                self.handleError(err)
                self.pageInfo.accept(nil)
            },
                onCompleted: {
                self.isLoading = false
                self.notifyRefreshEnded?()
            })
            // compactMap과 Optional+Ext을 통해서 들어온 response를 unwrapping 해준다.
            // Optional은 만약 meta나 data가 포함되지 않으면 nil 을 반환하는데,
            // compactMap을 통해서 nil이 밑의 로직으로 가지 않도록 한다.
            .compactMap{Optional(tuple: ($0.meta, $0.data))}
            .subscribe(onNext: { pageInfo, fetchedTodos in
                // 페이지 갱신
                if page == 1 {
                    self.todos.accept(fetchedTodos)
                } else {
                    let addedTodos = self.todos.value + fetchedTodos
                    self.todos.accept(addedTodos)
                }
                self.pageInfo.accept(pageInfo)
            }).disposed(by: disposeBag)
        // 딜레이를 주지 않고 하는 방법
        /*
        TodosAPI
            .fetchTodosWithObservable(page:page)
            .do(onCompleted: {
                self.isLoading = false
                self.notifyRefreshEnded?()
            })
            .subscribe(onNext: { response in
                // 페이지 갱신
                if let fetchedTodos = response.data,
                    let pageInfo : Meta = response.meta {
                    if page == 1 {
                        self.todos.accept(fetchedTodos)
                    } else {
                        let addedTodos = self.todos.value + fetchedTodos
                        self.todos.accept(addedTodos)
                    }
                    self.pageInfo = pageInfo
                }
            }).disposed(by: disposeBag)
         */
    }
    
    /// 단일 할 일 삭제
    /// - Parameter id: 삭제 할 할 일 아이디
    func deleteATodo(_ id: Int) {
        
        if isLoading {
            print("로딩 중 입니다.")
            return
        }
        
        self.isLoading = true
        
        TodosAPI.deleteATodo(id: id, completion: {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.isLoading = false
                // 여기에서는 다른 api들과 처리가 달라진다. 삭제된 데이터가 있을 때,
                // api를 다시 호출해서 전체를 보여주는 것이 아니라 테이블 뷰 내에서
                // 삭제된 하나의 셀만 지워주는 방식이다.
                if let deletedTodo: Todo = response.data,
                   let deletedTodoId: Int = deletedTodo.id {
                    // 삭제된 아이템 찾아서 현재 리스트에서 삭제
                    let filteredTodos = self.todos.value.filter{ $0.id ?? 0 != deletedTodoId }
                    self.todos.accept(filteredTodos)
                }
            case .failure(let failure):
                self.isLoading = false
                self.handleError(failure)
            }
        })
    }
    
    func editATodo(_ id: Int, _ editedTitle: String) {
        
        if isLoading {
            print("로딩 중 입니다.")
            return
        }
        
        self.isLoading = true

        TodosAPI.editATodo(id: id,
                           title: editedTitle,
                           completion: {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.isLoading = false

                if let editedTodo: Todo = response.data,
                   let editedTodoId: Int = editedTodo.id,
                   let editedIndex = self.todos.value.firstIndex(where: {$0.id ?? 0 == editedTodoId}) {
                    
                    // 지금 수정한 아이디를 가지고 있는 인덱스 찾기
                    // 그 인덱스에 해당하는 셀의 데이터만 변경
                    var currentTodos = self.todos.value
                    currentTodos[editedIndex] = editedTodo
                    
                    self.todos.accept(currentTodos)
                }
            case .failure(let failure):
                self.isLoading = false
                self.handleError(failure)
            }
            
        })
    }
    
    
    /// 선택된 할 일들 삭제
    func deleteSeletedTodos() {
        
        if self.selectedTodoIds.count < 1 {
            notifyErrorOccured?("선택된 할 일들이 없습니다.")
            return
        }
        
        if isLoading {
            print("로딩 중 입니다.")
            return
        }
        
        self.isLoading = true
        
        TodosAPI.deleteSeletedTodos(seletedTodoIds: Array(self.selectedTodoIds), completion: { [weak self] deletedTodoIds in
            guard let self = self else {return}
            
            let filterdTodos = self.todos.value.filter { !deletedTodoIds.contains($0.id ?? 0)}
            self.todos.accept(filterdTodos)
            
            self.selectedTodoIds = self.selectedTodoIds.filter { !deletedTodoIds.contains($0) }
            
            self.isLoading = false
        })
    }
    
    
    /// API 에러처리
    /// - Parameter err: API Error
    fileprivate func handleError(_ err: Error) {
        
        guard let apiError = err as? TodosAPI.ApiError else {
            print("모르는 에러입니다.")
            return
        }
        
        switch apiError {
        case .noContent:
            print(#fileID, #function, #line, "- 컨텐츠 없음")
            self.notifySearchDataNotFound?(true)
        case .unauthorized:
            print("인증 안됨")
        case .decodingError:
            print("디코딩 에러입니다.")
        case .errResponseFromServer:
            print("서버에서 온 에러입니다 : \(apiError.info)")
            self.notifyErrorOccured?(apiError.info)
        default:
            print(#fileID, #function, #line, "- handle error default")
        }
    }
}
