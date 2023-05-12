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
import RxCombine

class TodosVM: ObservableObject {
    
    var disposeBag = DisposeBag()
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        print(#fileID, #function, #line, "- ")
        
        var requestCount: Int = 0
        let retryCount: Int = 3
        
        // Async Retry
        let fetchTodosTask = Task.retry(retryCount: 3, delay: 2, when:{ err in
                                            if case TodosAPI.ApiError.noContent = err {
                                                return true
                                            }
                                            return false
                                        },asyncWork: {
                                            try await TodosAPI.fetchTodosWithAsync(page:999)
                                        })
        Task {
            do {
                let result = try await fetchTodosTask.value
                print(result)
            } catch {
                print("error : \(error)")
            }
        }
        
//        Task {
//            // 횟수 제한
//            for index in 0...retryCount {
//                do {
//                    let result = try await TodosAPI.fetchTodosWithAsync(page: 999)
//                    print("result : \(result)")
//                } catch {
//                    print("error: \(error)")
//
//                    // 조건 만들기
//                    // Error 종류가 noContent 일 때 Retry하도록 설정
//                    // Error 종류가 noContent가 아닐 때 error 출력
//                    guard case TodosAPI.ApiError.noContent = error else {
//                        throw error
//                    }
//
//                    // 딜레이
//                    try await Task.sleep(nanoseconds: UInt64(3 * 1_000_000_000))
//                    continue
//                }
//            }
//        }
        
        // Combin Retry
//        TodosAPI.fetchTodosWithPublisher(page:999)
//            .retryWithDelayAndCondition(retryCount: 3, delay: 2, when: { err in
//                if case TodosAPI.ApiError.noContent = err {
////                if case TodosAPI.ApiError.unauthorized = err {
//                    return true
//                }
//                return false
//            })
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    print("finished")
//                case .failure(let failure):
//                    print("failure : \(failure)")
//                }
//            } receiveValue: { response in
//                print("response : \(response)")
//            }.store(in: &subscriptions)
        
//        TodosAPI.fetchTodosWithPublisher(page:999)
//            .tryCatch({ err in
//
//                if case TodosAPI.ApiError.noContent = err {
//                    throw err
//                }
//
//                return Just(Void())
//                    .delay(for: 3, scheduler: DispatchQueue.main)
//                    .flatMap { _ in
//                        return TodosAPI.fetchTodosWithPublisher(page:999)
//                    }
//                    .retry(retryCount)
//                    .eraseToAnyPublisher()
//            })
////            .delay(for: 3, scheduler: DispatchQueue.main)
////            .retry(3)
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    print("finished")
//                case .failure(let failure):
//                    print("failure : \(failure)")
//                }
//            } receiveValue: { response in
//                print("response : \(response)")
//            }.store(in: &subscriptions)

        
        // Rx 리트라이
//        TodosAPI.fetchTodosWithObservable(page: 999)
//            .retryWithDelayAndCondition(
//                retryCount: 3,
//                delay: 2,
//                when: { err in
//                    if case TodosAPI.ApiError.unauthorized = err {
//                        return true
//                    }
//
//                    return false
//                })
//                .subscribe(onNext: {
//                    print("onNext : \($0)")
//                }, onError: {
//                    print("onError : \($0)")
//                }, onCompleted: {
//                    print("onComplete")
//                }, onDisposed: {
//                    print("onDisposed")
//                })
//                .disposed(by: disposeBag)
        
//        TodosAPI.fetchTodosWithObservable(page: 999)
//            // .retry(3) // delay X
//            .retry(when: { (observableErr : Observable<TodosAPI.ApiError>) in
//                observableErr
//                    .do(onNext: { err in
//                        print("observableErr - err : \(err) // requerstCount : \(requestCount)")
//                    })
//                    .flatMap { err in
//                        requestCount += 1
//                        guard requestCount < retryCount else {
//                            // retry(when:)을 종료하려면 여기서 에러를 던져주어야 한다.
//                            throw err
//                        }
//
//                        if case TodosAPI.ApiError.noContent = err {
//                            return Observable<Void>.just(()).delay(.seconds(3), scheduler: MainScheduler.instance)
//                        }
//
//                        // 위와 같은 로직
////                        if let apiErr = err as? TodosAPI.ApiError {
////                            switch apiErr {
////                            case .noContent:
////                                return Observable<Void>.just(()).delay(.seconds(3), scheduler: MainScheduler.instance)
////                            default: throw err
////                            }
////                        }
//
//                        throw err
//                        // 무한 루프
//                        // return Observable<Void>.just(())
//                    }
// //         .take(3)
//            })
//            .subscribe(onNext: {
//                print("onNext : \($0)")
//            }, onError: {
//                print("onError : \($0)")
//            }, onCompleted: {
//                print("onComplete")
//            }, onDisposed: {
//                print("onDisposed")
//            })
//            .disposed(by: disposeBag)
        
//        Observable
//            .just(99999)
//            .mapAsync { value in
//                try await TodosAPI.fetchTodosWithAsync(page: value)
//            }
//            .subscribe(onNext: {
//                print("onNext : \($0)")
//            }, onError: {
//                print("onError : \($0)")
//            }, onCompleted: {
//                print("onComplete")
//            }, onDisposed: {
//                print("onDisposed")
//            })
//            .disposed(by: disposeBag)
        
//        TodosAPI.genericAsyncToObservable(asyncWork: {
//            try await TodosAPI.fetchTodosWithAsync(page: 1)
//        })
//            .subscribe(onNext: {
//                print("onNext : \($0)")
//            }, onError: {
//                print("onError : \($0)")
//            }, onCompleted: {
//                print("onComplete")
//            }, onDisposed: {
//                print("onDisposed")
//            })
//            .disposed(by: disposeBag)
        
//        TodosAPI.fetchTodosAsyncToObservable()
//            .subscribe(onNext: {
//                print("onNext : \($0)")
//            }, onError: {
//                print("onError : \($0)")
//            }, onCompleted: {
//                print("onComplete")
//            }, onDisposed: {
//                print("onDisposed")
//            })
//            .disposed(by: disposeBag)
        
//        Just(1)
//            .mapAsyncr { value in
//                try await TodosAPI.fetchTodosWithAsync(page:value)
//            }
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    print("finished")
//                case .failure(let failure):
//                    print("failure : \(failure)")
//                }
//            } receiveValue: { response in
//                print("response : \(response)")
//            }
//            .store(in: &subscriptions)
        
//        TodosAPI.genericAsyncToPublisher(asyncWork: {
//            try await TodosAPI.fetchTodosWithAsync()
//        })
//        .sink { completion in
//            switch completion {
//            case .finished:
//                print("finished")
//            case .failure(let failure):
//                print("failure : \(failure)")
//            }
//        } receiveValue: { response in
//            print("response : \(response)")
//        }
//        .store(in: &subscriptions)
        
//        TodosAPI.fetchTodosAsyncToPublisher()
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    print("finished")
//                case .failure(let failure):
//                    print("failure : \(failure)")
//                }
//            } receiveValue: { response in
//                print("response : \(response)")
//            }
//            .store(in: &subscriptions)
        
        
//        TodosAPI.fetchTodosWithPublisher()
//            .asObservable()
//            .subscribe(onNext: {
//                print("onNext : \($0)")
//            }, onError: {
//                print("onError : \($0)")
//            }, onCompleted: {
//                print("onComplete")
//            }, onDisposed: {
//                print("onDisposed")
//            })
//            .disposed(by: disposeBag)

//        TodosAPI.fetchTodosWithObservable()
//            .publisher
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    print("finished")
//                case .failure(let failure):
//                    print("failure : \(failure)")
//                }
//            } receiveValue: { response in
//                print("response : \(response)")
//            }
//            .store(in: &subscriptions)
    }
// 변환
/*
 //
 //        Task {
 //            do {
 ////                let result = try await TodosAPI.fetchTodosWithObservableToAsync()
 //                let result = try await TodosAPI.fetchTodosWithObservable().toAsync()
 //                print("result : \(result)")
 //            } catch {
 //                print("catched error: \(error)")
 //            }
 //        }
         
 //        Task {
 //            do {
 //                // let result = try await TodosAPI.fetchTodosWithPublisherToAsync(page: 1)
 //                // async 부분을 extension으로 변경해서 API를 호출한다.
 //                let result = try await TodosAPI.fetchTodosWithPublisher().toAsync()
 //                print("result : \(result)")
 //            } catch {
 //                print("catched error: \(error)")
 //            }
 //        }
 //
 //        TodosAPI.fetchTodosClosureToPublisherWithNoError()
 //            .sink { completion in
 //                switch completion {
 //                case .failure(_):
 //                    print("failure")
 //                case .finished:
 //                    print("finished")
 //                }
 //            } receiveValue: { response in
 //                print("response : \(response)")
 //            }
 //            .store(in: &subscriptions)
 //
 //        TodosAPI.fetchTodosClosureToPublisherWithError(page: 1)
 //            .sink { completion in
 //                switch completion {
 //                case .failure(let failure):
 //                    print("failure: \(failure)")
 //                case .finished:
 //                    print("finished")
 //                }
 //            } receiveValue: { response in
 //                print("response : \(response)")
 //            }
 //            .store(in: &subscriptions)

         
 //        TodosAPI.fetchTodosClosureToObservable(page: 1)
 //            .subscribe(onNext: { value in
 //                print("value: \(value)")
 //            }, onError: { err in
 //                print("error: \(err)")
 //            })
 //            .disposed(by: disposeBag)
         
 //        Task {
 //            let result = await TodosAPI.fetchTodosClosureToAsyncReturnArray(page:1)
 //            print("result: \(result)")
             
 //            do {
 //                let result = try await TodosAPI.fetchTodosClosureToAsyncWithError(page:1)
 //                print("result: \(result)")
 //            } catch {
 //                self.handleError(error)
 //            }
 //        }
         
 //        Task {
 //            let result = await TodosAPI.fetchTodosClosureToAsync(page: 1)
 //            print("result : \(result)")
 //        }
 */
// async/await
/*
//        Task {
//            let selectedIds : [Int] = [3540, 3521,3526, 3528, 3529, 3531, 3532]
//            let response = await TodosAPI.deleteSeletedTodosWithAsyncTaskGroupNoError(selectedTodoIds: selectedIds)
//            print("결과 : \(response)")
//        }
        
//        Task {
//            do {
//                let selectedIds : [Int] = [3540, 3521,3526, 3528, 3529, 3531, 3532]
//                let response = try await TodosAPI.deleteSeletedTodosWithAsyncTaskGroupWithError(selectedTodoIds: selectedIds)
//                print("결과 : \(response)")
//            } catch {
//                self.handleError(error)
//            }
//        }
//
//        Task {
//            do {
//                let response : [Int] = try await TodosAPI.deleteSeletedTodosWithAsyncWithError(selectedTodoIds: [])
//            } catch {
//                self.handleError(error)
//            }
//        }
//
//        Task {
//            let response : [Int] = try await TodosAPI.deleteSeletedTodosWithAsyncNoError(selectedTodoIds: [])
//        }
//
//        Task {
//            let response = await TodosAPI.addTodoAndFetchTodosWithAsyncNoErr(title: "새롭게 추가된 할 일 입니다.")
//            print("response : \(response)")
//        }
//
        
//        Task {
//            do {
//                let response = try await TodosAPI.fetchTodosWithAsync(page: 1)
//                print("fetchTodosWithAsync")
//                guard let data = response.data else { return }
//
//                for i in data {
//                    print("\(i.id!), \(i.title!)")
//                }
//
//            } catch {
//                self.handleError(error)
//            }
//        }
        
//        for i in (0...30) {
//            Task {
//                do {
//                    let response = try await TodosAPI.addATodoJSONWithAsync(title: "할 일을 추가합니다. \(i)")
//                } catch {
//                    self.handleError(error)
//                }
//            }
//        }

//
//        Task {
//            do {
//                let response = try await TodosAPI.searchTodosWithAsync(searchTerm: "작성하기")
//                print("Async: \(response)")
//            } catch {
//                self.handleError(error)
//            }
//        }
        
//        Task {
//            let response = await TodosAPI.fetchTodosWithAsyncResult()
//            print("Async Result : \(response)")
//        }
*/
// Combine
/*
//        TodosAPI.fetchTodosWithPublisherResult()
//            .sink { result in
//                switch result {
//                case .failure(let failure):
//                    self.handleError(failure)
//                case .success(let baseListTodoResponse):
//                    guard let dataList = baseListTodoResponse.data else {return}
//                    for i in dataList {
//                        print("id: \(i.id)")
//                    }
//                }
//            }.store(in: &subscriptions)
//        TodosAPI.fetchSeletedTodosWithPublisherMerge(seletedTodoIds: [3277, 3403, 3483, 3484])
//            .sink { [weak self] completion in
//                guard let self = self else {return}
//                switch completion {
//                case .failure(let failure):
//                    self.handleError(failure)
//                case .finished:
//                    print(#fileID, #function, #line, "- finished")
//                }
//            } receiveValue: { response in
//                print(#fileID, #function, #line, "- Merge 검색:: \(response)")
//            }.store(in: &subscriptions)
//
//        TodosAPI.deleteSeletedTodosWithPublisherZip(seletedTodoIds: [3481, 3482, 3509, 3506])
//            .sink { [weak self] completion in
//                guard let self = self else {return}
//                switch completion {
//                case .failure(let failure):
//                    self.handleError(failure)
//                case .finished:
//                    print(#fileID, #function, #line, "- finished")
//                }
//            } receiveValue: { response in
//                print(#fileID, #function, #line, "- 삭제:: \(response)")
//            }.store(in: &subscriptions)

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

*/
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
