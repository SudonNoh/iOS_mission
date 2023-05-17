//
//  TodosVM.swift
//  TodoAppTutorial
//
//  Created by Sudon Noh on 2023/05/02.
//

import Foundation

class TodosVM_Closure {
    
    // 가공된 최종 데이터
    var todos : [Todo] = [] {
        didSet {
            //MARK: - MVVM 구현 로직 5
            // 5.notifyTodosChanged에 todos 를 매개변수로 넣어준다.
            // 이때 notifyTodosChanged 의 상태는 아래와 같다고 할 수 있다.
            // notifyTodosChanged = { todos in }
            // 이제 이것이 호출하면 todos 를 매개변수로 받는 클로저 함수를 만들 수 있다.
            self.notifyTodosChanged?(todos)
        }
    }
    
    // 선택된 할일 목록
    var selectedTodoIds: Set<Int> = [] {
        didSet {
            print(#fileID, #function, #line, "- selectedTodoIds: \(selectedTodoIds)")
            self.notifySeletedTodoIdsChanged?(Array(selectedTodoIds))
        }
    }
    
    // 페이지 정보
    var pageInfo : Meta? = nil {
        didSet {
            // 다음페이지 있는지 여부 이벤트 보내기
            self.notifyHasNextPage?( pageInfo?.hasNext() ?? true)
            
            // 현재 페이지 변경 이벤트
            self.notifyCurrentPageChanged?(currentPage)
        }
    }
    
    // 현재 페이지
    var currentPage : Int {
        get {
            if let pageInfo = self.pageInfo,
               let currentPage = pageInfo.currentPage {
                return currentPage
            } else {
                return 1
            }
        }
    }
    
    // 로딩 여부 변경 이벤트
    var isLoading : Bool = false {
        didSet{
            self.notifyLoadingStateChanged?(isLoading)
        }
    }
    
    // 리프레시 완료 이벤트
    var notifyRefreshEnded : (()->Void)? = nil
    
    /// 검색어
    var searchTerm: String = "" {
        didSet {
            if searchTerm.count > 0 {
                self.searchTodos(searchTerm: searchTerm)
            } else {
                self.fetchTodos()
            }
        }
    }
    
    // 검색결과 없음 여부 이벤트
    var notifySearchDataNotFound: ((_ noContent: Bool)->Void)? = nil
    
    var notifyHasNextPage: ((_ hasNext: Bool)->Void)? = nil
    
    // 데이터 변경 이벤트
    var notifyTodosChanged : (([Todo]) -> Void)? = nil
    
    var notifyCurrentPageChanged : ((Int) -> Void)? = nil
    
    var notifyLoadingStateChanged : ((_ isLoading: Bool) -> Void)? = nil
    
    // 할 일 추가 완료 이벤트
    var notifyTodoAdded : (() -> Void)? = nil
    
    // 에러 발생 이벤트
    var notifyErrorOccured : ((_ errMsg: String) -> Void)? = nil
    
    // 선택된 할 일들 변경 이벤트
    var notifySeletedTodoIdsChanged: ((_ selectedIds: [Int]) -> Void)? = nil

    init() {
        
        //MARK: - MVVM 구현 로직 2
        // 2.TodosVM() 로직이 실행되면서 init() 부분이 동작하고 fetchTodos() 함수가 실행된다.
        fetchTodos()
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
        
        guard let pageInfo = self.pageInfo,
              pageInfo.hasNext(),
              !isLoading else {
            return print("다음 페이지가 없습니다.")
        }
        
        if searchTerm.count > 0 {
            // 검색어가 있는 경우
            self.searchTodos(searchTerm: searchTerm, page: self.currentPage+1)
        } else {
            self.fetchTodos(page: currentPage + 1)
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
                    self.todos = fetchedTodos
                    self.pageInfo = pageInfo
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
        
        guard pageInfo?.hasNext() ?? true else {
            return print("다음 페이지 없음")
        }
        
        self.notifySearchDataNotFound?(false)
        
        // 현재 페이지가 1일 때만
        if page == 1 {
            self.todos = []
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
                            self.todos = fetchedTodos
                        } else {
                            self.todos.append(contentsOf: fetchedTodos)
                        }
                        
                        self.pageInfo = pageInfo
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
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.7, execute: {
            // 서비스 로직
            //MARK: - MVVM 구현 로직 3
            // 3.서비스 로직이 실행된다.
            TodosAPI.fetchTodos(page:page, completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    
                    self.isLoading = false
                    
                    if let fetchedTodos = response.data,
                        let pageInfo : Meta = response.meta {
                        if page == 1 {
                            //MARK: - MVVM 구현 로직 4
                            // 4.self.todos의 값이 변경되면서 self.todos의 didSet()이 동작한다.
                            self.todos = fetchedTodos
                        } else {
                            self.todos.append(contentsOf: fetchedTodos)
                        }
                        self.pageInfo = pageInfo
                    }
                    
                case .failure(let failure):
                    print("failure : \(failure)")
                    self.isLoading = false
                    self.handleError(failure)
                    
                }
                self.notifyRefreshEnded?()
                
            })
        })
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
                    self.todos = self.todos.filter{ $0.id ?? 0 != deletedTodoId }
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
                   let editedIndex = self.todos.firstIndex(where: {$0.id ?? 0 == editedTodoId}) {
                    
                    // 지금 수정한 아이디를 가지고 있는 인덱스 찾기
                    // 그 인덱스에 해당하는 셀의 데이터만 변경
                    self.todos[editedIndex] = editedTodo
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
            
            self.todos = self.todos.filter { !deletedTodoIds.contains($0.id ?? 0)}
            
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
