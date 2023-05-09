//
//  TodosVM.swift
//  TodoAppTutorial
//
//  Created by Sudon Noh on 2023/05/02.
//

import Foundation
import Combine
import RxSwift
import RxRelay


class TodosVM: ObservableObject {
    
    var disposeBag = DisposeBag()
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        print(#fileID, #function, #line, "- ")

        // Combine
//        TodosAPI.addTodoAndFetchTodosWithPublisher(title: "새롭게 추가된 데이터입니다. 5월 9일 !")
//                .sink { [weak self] completion in
//                    guard let self = self else {return}
//                    switch completion {
//                    case .failure(let failure):
//                        self.handleError(failure)
//                    case .finished:
//                        print(#fileID, #function, #line, "- finished")
//                    }
//                } receiveValue: { response in
//                    print(#fileID, #function, #line, "- \(response)")
//                }.store(in: &subscriptions)
        
//        TodosAPI.deleteATodoWithPublisher(id: 3501)
//            .sink { [weak self] completion in
//                guard let self = self else {return}
//                switch completion {
//                case .failure(let failure):
//                    self.handleError(failure)
//                case .finished:
//                    print(#fileID, #function, #line, "- finished")
//                }
//            } receiveValue: { response in
//                print(#fileID, #function, #line, "- \(response)")
//            }.store(in: &subscriptions)

        
//        TodosAPI.editATodoWithPublisher(id: 3501, title: "새롭게 수정된 아이템입니다. 확인 부탁드립니다. 333")
//            .sink { [weak self] completion in
//                guard let self = self else { return }
//                switch completion {
//                case .failure(let failure):
//                    self.handleError(failure)
//                case .finished:
//                    print(#fileID, #function, #line, "- finished")
//                }
//            } receiveValue: { response in
//                print(#fileID, #function, #line, "- \(response)")
//            }.store(in: &subscriptions)
//
//        TodosAPI.searchTodosWithPublisher(searchTerm: "새롭게")
//            .sink { [weak self] completion in
//                guard let self = self else { return }
//                switch completion {
//                case .failure(let failure):
//                    self.handleError(failure)
//                case .finished:
//                    print(#fileID, #function, #line, "- finished")
//                }
//            } receiveValue: { response in
//                print(#fileID, #function, #line, "- \(response)")
//            }.store(in: &subscriptions)

//        TodosAPI.addATodoJSONWithPublisher(title: "새롭게 추가된 할 일 입니다.3")
//            .sink { [weak self] completion in
//                guard let self = self else { return }
//                switch completion {
//                case .failure(let failure):
//                    self.handleError(failure)
//                case .finished:
//                    print(#fileID, #function, #line, "- finished")
//                }
//            } receiveValue: { response in
//                print(#fileID, #function, #line, "- \(response)")
//            }.store(in: &subscriptions)
        
//        TodosAPI.addATodoWithPublisher(title: "새롭게 추가된 할 일 입니다.2")
//            .sink { [weak self] completion in
//                guard let self = self else { return }
//                switch completion {
//                case .failure(let failure):
//                    self.handleError(failure)
//                case .finished:
//                    print(#fileID, #function, #line, "- finished")
//                }
//            } receiveValue: { response in
//                print(#fileID, #function, #line, "- \(response)")
//            }.store(in: &subscriptions)

        
//        TodosAPI.fetchATodoWithPublisher(id: 3487)
//            .sink { [weak self] completion in
//
//                guard let self = self else { return }
//                switch completion {
//                case .failure(let failure):
//                    self.handleError(failure)
//                case .finished:
//                    print(#fileID, #function, #line, "- finished")
//                }
//            } receiveValue: { response in
//                print(#fileID, #function, #line, "- \(response)")
//            }.store(in: &subscriptions)
        
        //        TodosAPI.fetchTodosWithPublisher()
        //            .sink { [weak self] completion in
        //                guard let self = self else {return}
        //                switch completion {
        //                case .failure(let failure):
        //                    self.handleError(failure)
        //                case .finished:
        //                    print(#fileID, #function, #line, "- finished")
        //                }
        //            } receiveValue: { response in
        //                print(#fileID, #function, #line, "- \(response)")
        //            }.store(in: &subscriptions)

            
        //        TodosAPI.fetchTodosWithPublisherResult()
        //            .sink { result in
        //                switch result {
        //                case .failure(let failure):
        //                    self.handleError(failure)
        //                case .success(let baseListTodoResponse):
        //                    print(#fileID, #function, #line, "- fetchTodosWithPublisher/baseListTodoResponse: \(baseListTodoResponse)")
        //                }
        //            }.store(in: &subscriptions)
            
    }

        
// Rx
/*
//            TodosAPI.deleteSeletedTodosWithObservableMerge(seletedTodoIds: [3480, 3485, 3490, 3486, 3493])
//                .subscribe(onNext:  { deletedTodos in
//                    print(#fileID, #function, #line, "- deletedTodos: \(deletedTodos)")
//                }, onError: { err in
//                    print(#fileID, #function, #line, "- err: \(err)")
//                })
//                .disposed(by: disposeBag)
        
//        TodosAPI.deleteSeletedTodosWithObservable(seletedTodoIds: [3488, 3494, 3497])
//            .subscribe(onNext:  { deletedTodos in
//                print(#fileID, #function, #line, "- deletedTodos: \(deletedTodos)")
//            }, onError: { err in
//                print(#fileID, #function, #line, "- err: \(err)")
//            })
//            .disposed(by: disposeBag)
        
//        // 두 번째 방법 : 이 경우 [Todo] 배열이나 빈 배열을 받을 수 있다.
//        // 뿐만 아니라, 에러가 나더라도 빈 배열이 들어오기 때문에 onError를 사용하지 않아도 된다.
//        TodosAPI.addTodoAndFetchTodosWithObservable2(title: "23.05.04 17:56 추가합니다")
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: {[weak self] (response: [Todo]) in
//                print(#fileID, #function, #line, "- \(response)")
//            }).disposed(by: disposeBag)
        
//        // 첫 번째 방법
//        TodosAPI.addTodoAndFetchTodosWithObservable(title: "23.05.04 17:56 추가합니다")
//            .observe(on: MainScheduler.instance)
//            .compactMap{ $0.data }
//            .subscribe(onNext: {[weak self] (response: [Todo]) in
//                print(#fileID, #function, #line, "- \(response)")
//            }, onError: {[weak self] failure in
//                self?.handleError(failure)
//            }).disposed(by: disposeBag)
        
//        TodosAPI.deleteATodoWithObservable(id: 3461)
//            .observe(on: MainScheduler.instance)
//            .compactMap{ $0.data }
//            .subscribe(onNext: {[weak self] (response: Todo) in
//                print(#fileID, #function, #line, "- \(response)")
//            }, onError: {[weak self] failure in
//                self?.handleError(failure)
//            }).disposed(by: disposeBag)
        
        
//        TodosAPI.editATodoWithObservable(id: 3461, title: "23.05.04 16:40 추가합니다2 -> 수정합니다2")
//            .observe(on: MainScheduler.instance)
//            .compactMap{ $0.data }
//            .subscribe(onNext: {[weak self] (response: Todo) in
//                print(#fileID, #function, #line, "- \(response)")
//            }, onError: {[weak self] failure in
//                self?.handleError(failure)
//            }).disposed(by: disposeBag)
        
//        TodosAPI.addATodoJSONWithObservable(title: "23.05.04 16:40 추가합니다2", isDone: false)
//            .observe(on: MainScheduler.instance)
//            .compactMap{ $0.data } // Todo
//            .subscribe(onNext: {[weak self] (response: Todo) in
//                print(#fileID, #function, #line, "- \(response)")
//            }, onError: {[weak self] failure in
//                self?.handleError(failure)
//            }).disposed(by:disposeBag)
        
//        TodosAPI.addATodoWithObservable(title: "23.05.04 16:40 추가합니다", isDone: false)
//            .observe(on: MainScheduler.instance)
//            .compactMap { $0.data } // Todo
//            .subscribe(onNext: {[weak self] (response: Todo) in
//                print(#fileID, #function, #line, "- \(response)")
//            }, onError: {[weak self] failure in
//                self?.handleError(failure)
//            }).disposed(by: disposeBag)
//        
        
//        TodosAPI.searchTodosWithObservable(searchTerm: "빡코딩")
//            .observe(on: MainScheduler.instance)
//            .compactMap { $0.data } // [Todo]
//            .subscribe(onNext: {[weak self] (response: [Todo]) in
//                print(#fileID, #function, #line, "- \(response)")
//            }, onError: {[weak self] failure in
//                self?.handleError(failure)
//            }).disposed(by: disposeBag)
        
//        TodosAPI.fetchATodoWithObservable(id: 3422)
//            .observe(on: MainScheduler.instance)
//            .compactMap { $0.data } // Todo
//            .subscribe(onNext: {[weak self] (response: Todo) in
//                print(#fileID, #function, #line, "- \(response)")
//            }, onError: {[weak self] failure in
//                self?.handleError(failure)
//            }).disposed(by: disposeBag)
        
//        TodosAPI.fetchTodosWithObservable()
//            .observe(on: MainScheduler.instance)
//            .compactMap{ $0.data } // [Todo]
//            // compactMap을 사용하고 응답이 왔는데, error가 나오면 아래 과정 진행
//            .catch({err in
//                print(#fileID, #function, #line, "- err: \(err)")
//                // error 가 나오면 빈 배열을 반환한다.
//                return Observable.just([])
//            })
//            // .subscribe(onNext: {[weak self] (response: BaseListResponse<Todo>) in
//            // compactMap을 사용한 경우
//            .subscribe(onNext: {[weak self] (response: [Todo]) in
//                print(#fileID, #function, #line, "- response: \(response)")
//
//                for i in response {
//                    guard let id = i.id else {return}
//                    guard let title = i.title else {return}
//                    print("- title : \(id) - \(title)")
//                }
//
//            }, onError: {[weak self] failure in
//                self?.handleError(failure)
//            }).disposed(by: disposeBag)

//        // 모든 할 일 가져오기
        TodosAPI.fetchTodosWithObservableResult()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext:{[weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let failure):
                    self.handleError(failure)
                case .success(let response):
                    print(#fileID, #function, #line, "- response: \(response)")
                }
            }
            ).disposed(by: disposeBag)
    }
*/
// Closure
/*
//        TodosAPI.fetchSeletedTodos(seletedTodoIds: [3451, 3449], completion: { result in
//            switch result {
//            case .success(let data):
//                print(#fileID, #function, #line, "- data : \(data)")
//            case .failure(let failure):
//                print(#fileID, #function, #line, "- failure : \(failure)")
//            }
//        })
        
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
 */
    
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
