//
//  TodosVM.swift
//  TodoAppTutorial
//
//  Created by Sudon Noh on 2023/05/02.
//

import Foundation
import Combine


class TodosVM: ObservableObject {
    
    init() {
        print(#fileID, #function, #line, "- ")
        
        TodosAPI.fetchSeletedTodos(seletedTodoIds: [3451, 3449], completion: { result in
            switch result {
            case .success(let data):
                print(#fileID, #function, #line, "- data : \(data)")
            case .failure(let failure):
                print(#fileID, #function, #line, "- failure : \(failure)")
            }
        })
        
//        TodosAPI.deleteSeletedTodos(seletedTodoIds: [3285, 3421, 3326], completion: { [weak self] deletedTodos in
//            print("TodosVM deleteSeletedTodos - todolistResponse: \(deletedTodos)")
//        })
        
//        TodosAPI.addTodoAndFetchTodos(title: "addTodoAndFetchTodos 추가함", completion: { [weak self] result in
//
//            guard let self = self else { return }
//
//            switch result {
//            case .success(let todoListResponse):
//                print("TodoVM - todoListResponse: \(todoListResponse)")
//            case .failure(let failure):
//                print("TodoVM - failure: \(failure)")
//                self.handleError(failure)
//            }
//        })
        
        
//        // 특정 할 일 수정
//        TodosAPI.deleteATodo(id: 3457, completion: { [weak self] result in
//
//            guard let self = self else { return }
//
//            switch result {
//            case .success(let aTodoResponse):
//                print("TodoVM delete - aTodoResponse: \(aTodoResponse)")
//            case .failure(let failure):
//                print("TodoVM delete - failure: \(failure)")
//                self.handleError(failure)
//            }
//        })
        
//        // 특정 할 일 수정
//        TodosAPI.editTodoJson(id: 3457,title: "수정되었습니다.", isDone: true, completion: { [weak self] result in
//
//            guard let self = self else { return }
//
//            switch result {
//            case .success(let aTodoResponse):
//                print("TodoVM addATodo - aTodoResponse: \(aTodoResponse)")
//            case .failure(let failure):
//                print("TodoVM addATodo - failure: \(failure)")
//                self.handleError(failure)
//            }
//        })
        
//        // JSON으로 추가하기
//        TodosAPI.addATodoJSON(title:"안녕하세요. 모두모두 화이팅❤", isDone: true, completion: { [weak self] result in
//
//            guard let self = self else { return }
//
//            switch result {
//            case .success(let aTodoResponse):
//                print("TodoVM addATodo - aTodoResponse: \(aTodoResponse)")
//            case .failure(let failure):
//                print("TodoVM addATodo - failure: \(failure)")
//                self.handleError(failure)
//            }
//        })
//
        
        
//        // 검색해서 가져오기
//        TodosAPI.searchTodos(searchTerm: "빡코딩", completion: { [weak self] result in
//
//            guard let self = self else { return }
//
//            switch result {
//            case .success(let todosResponse):
//                print("TodosVM - todosResponse: \(todosResponse)")
//            case .failure(let failure):
//                print("TodosVM - failure: \(failure)")
//                self.handleError(failure)
//            }
//        })
        
//        // 특정 할 일 목록 가져오기
//        TodosAPI.fetchATodo(id: 3454, completion: { [weak self] result in
//
//            guard let self = self else { return }
//
//            switch result {
//            case .success(let aTodoResponse):
//                print("TodoVM - aTodoResponse: \(aTodoResponse)")
//            case .failure(let failure):
//                print("TodoVM - failure: \(failure)")
//                self.handleError(failure)
//            }
//        })
//
//        // 모든 할 일 목록 가져오기
//        TodosAPI.fetchTodos { [weak self] result in
//
//            guard let self = self else { return }
//
//            switch result {
//            case .success(let todosResponse):
//                print("TodosVM - todosResponse: \(todosResponse)")
//            case .failure(let failure):
//                print("TodosVM - failure: \(failure)")
//                self.handleError(failure)
//            }
//        }
    }
    
    
    /// API 에러처리
    /// - Parameter err: API Error
    fileprivate func handleError(_ err: Error) {
        if err is TodosAPI.ApiError {
            let apiError = err as! TodosAPI.ApiError
            switch apiError {
            case .noContent:
                print("컨텐츠 없음")
            case .unauthorized:
                print("인증 안됨")
            default:
                print("handleError - default")
            }
        }
    }
}
