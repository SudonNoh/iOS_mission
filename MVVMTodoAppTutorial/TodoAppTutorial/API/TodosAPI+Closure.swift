//
//  TodosAPI+Closure.swift
//  TodoAppTutorial
//
//  Created by Sudon Noh on 2023/05/03.
//

import Foundation
import MultipartForm
import RxSwift
import Combine

extension TodosAPI {
    /// 모든 할 일 목록 가져오기
    static func fetchTodos(
        page: Int = 1,
        completion: @escaping (Result<BaseListResponse<Todo>, ApiError>) -> Void
    ) {
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos" + "?page=\(page)"
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(ApiError.notAllowedUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다.
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, err in
            
            // 3. API 호출에 대한 응답을 받는다.
            // print("data : \(data)")
            // print("urlResponse : \(urlResponse)")
            // print("err : \(err)")
            
            if let error = err {
                return completion(.failure(ApiError.unknown(error)))
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                return completion(.failure(ApiError.unknown(nil)))
            }
            
            switch httpResponse.statusCode {
            case 401:
                return completion(.failure(ApiError.unauthorized))
            default: print("default")
            }
            
            if  !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                do {
                    // json으로 되어있는 데이터를 struct로 변경, 즉 디코딩/데이터 파싱
                    let listResponse = try JSONDecoder().decode(BaseListResponse<Todo>.self, from: jsonData)
                    let todos = listResponse.data
                    print("todosResponse : \(listResponse)")
                    
                    // 상태 코드는 200인데, 파싱한 데이터에 따라서 에러처리가 되는 경우
                    guard let todos = todos,
                          !todos.isEmpty else {
                        return completion(.failure(ApiError.noContent))
                    }
                    
                    completion(.success(listResponse))
                } catch {
                    completion(.failure(ApiError.decodingError))
                }
            }
        }.resume()
        
        
    }
  
    /// 특정 할 일 목록 가져오기
    static func fetchATodo(
        id: Int,
        completion: @escaping (Result<BaseResponse<Todo>, ApiError>) -> Void
    ) {
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos" + "/\(id)"
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(ApiError.notAllowedUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다.
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, err in
            
            // 3. API 호출에 대한 응답을 받는다.
            // print("data : \(data)")
            // print("urlResponse : \(urlResponse)")
            // print("err : \(err)")
            
            if let error = err {
                return completion(.failure(ApiError.unknown(error)))
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                return completion(.failure(ApiError.unknown(nil)))
            }
            
            switch httpResponse.statusCode {
            case 401:
                return completion(.failure(ApiError.unauthorized))
            case 204:
                return completion(.failure(ApiError.noContent))
            default: print("default")
            }
            
            if  !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                do {
                    // json으로 되어있는 데이터를 struct로 변경, 즉 디코딩/데이터 파싱
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: jsonData)
                    print("todoResponse : \(baseResponse)")
                    
                    completion(.success(baseResponse))
                } catch {
                    completion(.failure(ApiError.decodingError))
                }
            }
        }.resume()
    }
    
    /// 할 일 검색하기
    static func searchTodos(
        searchTerm: String,
        page: Int = 1,
        completion: @escaping (Result<BaseListResponse<Todo>, ApiError>) -> Void
    ) {
        // 1. urlRequest를 만든다.
        
        let requestUrl = URL(baseUrl: baseURL + "/todos/search", queryItems: ["query" : searchTerm, "page" : "\(page)"])
        
        /*
        var urlComponents = URLComponents(string: baseURL + "/todos/search")
        urlComponents?.queryItems = [
            URLQueryItem(name: "query", value: searchTerm),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        guard let url = urlComponents?.url else {
            return completion(.failure(ApiError.notAllowedUrl))
        }
         */
        
        guard let url = requestUrl else {
            return completion(.failure(ApiError.notAllowedUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다.
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, err in
            
            // 3. API 호출에 대한 응답을 받는다.
            // print("data : \(data)")
            // print("urlResponse : \(urlResponse)")
            // print("err : \(err)")
            
            if let error = err {
                return completion(.failure(ApiError.unknown(error)))
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                return completion(.failure(ApiError.unknown(nil)))
            }
            
            switch httpResponse.statusCode {
            case 401:
                return completion(.failure(ApiError.unauthorized))
            case 204:
                return completion(.failure(ApiError.noContent))
            default: print("default")
            }
            
            if  !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                do {
                    // json으로 되어있는 데이터를 struct로 변경, 즉 디코딩/데이터 파싱
                    let listResponse = try JSONDecoder().decode(BaseListResponse<Todo>.self, from: jsonData)
                    let todos = listResponse.data
                    print("todosResponse : \(listResponse)")
                    
                    // 상태 코드는 200인데, 파싱한 데이터에 따라서 에러처리가 되는 경우
                    guard let todos = todos,
                          !todos.isEmpty else {
                        return completion(.failure(ApiError.noContent))
                    }
                    
                    completion(.success(listResponse))
                } catch {
                    completion(.failure(ApiError.decodingError))
                }
            }
        }.resume()
        
        
    }
    
    
    /// 할 일 추가하기
    /// - Parameters:
    ///   - title: 할 일 타이틀
    ///   - isDone: 할 일 완료 여부
    ///   - completion: 응답 결과
    static func addATodo(
        title: String,
        isDone: Bool = false,
        completion: @escaping (Result<BaseResponse<Todo>, ApiError>) -> Void
    ) {
        
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos"
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(ApiError.notAllowedUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // urlRequest - MultipartForm 형태로 만들어 준다.
        let form = MultipartForm(parts: [
            MultipartForm.Part(name: "title", value: title),
            MultipartForm.Part(name: "is_done", value: "\(isDone)")
        ])
        
        urlRequest.addValue(form.contentType, forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpBody = form.bodyData
        
        // 2. urlSession으로 API를 호출한다.
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, err in
            
            // 3. API 호출에 대한 응답을 받는다.
            // print("data : \(data)")
            // print("urlResponse : \(urlResponse)")
            // print("err : \(err)")
            
            if let error = err {
                return completion(.failure(ApiError.unknown(error)))
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                return completion(.failure(ApiError.unknown(nil)))
            }
            
            switch httpResponse.statusCode {
            case 401:
                return completion(.failure(ApiError.unauthorized))
            case 422:
                if let data = data,
                   let errResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    return completion(.failure(ApiError.errResponseFromServer(errResponse)))
                }
            case 204:
                return completion(.failure(ApiError.noContent))
            default: print("default")
            }
            
            if  !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                do {
                    // json으로 되어있는 데이터를 struct로 변경, 즉 디코딩/데이터 파싱
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: jsonData)
                    print("todoResponse : \(baseResponse)")
                    
                    completion(.success(baseResponse))
                } catch {
                    completion(.failure(ApiError.decodingError))
                }
            }
        }.resume()
        
        
    }
    
    
    /// 할 일 추가하기(JSON)
    /// - Parameters:
    ///   - title: 할 일 타이틀
    ///   - isDone: 할 일 완료 여부
    ///   - completion: 응답 결과
    static func addATodoJSON(
        title: String,
        isDone: Bool = false,
        completion: @escaping (Result<BaseResponse<Todo>, ApiError>) -> Void
    ) {
        
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos-json"
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(ApiError.notAllowedUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestParams : [String : Any] = ["title":title, "is_done":"\(isDone)"]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestParams, options: [.prettyPrinted])
            urlRequest.httpBody = jsonData
        } catch {
            return completion(.failure(ApiError.jsonEncodingError))
        }
        
        // 2. urlSession으로 API를 호출한다.
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, err in
            
            // 3. API 호출에 대한 응답을 받는다.
            // print("data : \(data)")
            // print("urlResponse : \(urlResponse)")
            // print("err : \(err)")
            
            if let error = err {
                return completion(.failure(ApiError.unknown(error)))
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                return completion(.failure(ApiError.unknown(nil)))
            }
            
            switch httpResponse.statusCode {
            case 401:
                return completion(.failure(ApiError.unauthorized))
            case 204:
                return completion(.failure(ApiError.noContent))
            default: print("default")
            }
            
            if  !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                do {
                    // json으로 되어있는 데이터를 struct로 변경, 즉 디코딩/데이터 파싱
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: jsonData)
                    print("todoResponse : \(baseResponse)")
                    
                    completion(.success(baseResponse))
                } catch {
                    completion(.failure(ApiError.decodingError))
                }
            }
        }.resume()
        
        
    }
    
    
    /// 할 일 수정하기
    /// - Parameters:
    ///   - id: 수정할 아이템 아이디
    ///   - title: 할 일 타이틀
    ///   - isDone: 할 일 완료 여부
    ///   - completion: 응답 결과
    static func editTodoJson(
        id: Int,
        title: String,
        isDone: Bool = false,
        completion: @escaping (Result<BaseResponse<Todo>, ApiError>) -> Void
    ) {
        
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos-json/\(id)"
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(ApiError.notAllowedUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestParams : [String : Any] = ["title":title, "is_done":"\(isDone)"]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestParams, options: [.prettyPrinted])
            urlRequest.httpBody = jsonData
        } catch {
            return completion(.failure(ApiError.jsonEncodingError))
        }
        
        // 2. urlSession으로 API를 호출한다.
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, err in
            
            // 3. API 호출에 대한 응답을 받는다.
            // print("data : \(data)")
            // print("urlResponse : \(urlResponse)")
            // print("err : \(err)")
            
            if let error = err {
                return completion(.failure(ApiError.unknown(error)))
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                return completion(.failure(ApiError.unknown(nil)))
            }
            
            switch httpResponse.statusCode {
            case 401:
                return completion(.failure(ApiError.unauthorized))
            case 204:
                return completion(.failure(ApiError.noContent))
            default: print("default")
            }
            
            if  !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                do {
                    // json으로 되어있는 데이터를 struct로 변경, 즉 디코딩/데이터 파싱
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: jsonData)
                    print("todoResponse : \(baseResponse)")
                    
                    completion(.success(baseResponse))
                } catch {
                    completion(.failure(ApiError.decodingError))
                }
            }
        }.resume()
        
        
    }
    
    
    /// 할 일 수정하기 - PUT urlEncoded
    /// - Parameters:
    ///   - id: 삭제할 아이템 아이디
    ///   - title: 할 일 타이틀
    ///   - isDone: 할 일 완료 여부
    ///   - completion: 응답 결과
    static func editATodo(
        id: Int,
        title: String,
        isDone: Bool = false,
        completion: @escaping (Result<BaseResponse<Todo>, ApiError>) -> Void
    ) {
        
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos/\(id)"
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(ApiError.notAllowedUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let requestParams : [String : String] = ["title":title, "is_done":"\(isDone)"]
        
        urlRequest.percentEncodeParameters(parameters: requestParams)
        
        // 2. urlSession으로 API를 호출한다.
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, err in
            
            // 3. API 호출에 대한 응답을 받는다.
            // print("data : \(data)")
            // print("urlResponse : \(urlResponse)")
            // print("err : \(err)")
            
            if let error = err {
                return completion(.failure(ApiError.unknown(error)))
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                return completion(.failure(ApiError.unknown(nil)))
            }
            
            switch httpResponse.statusCode {
            case 401:
                return completion(.failure(ApiError.unauthorized))
            case 204:
                return completion(.failure(ApiError.noContent))
            default: print("default")
            }
            
            if  !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                do {
                    // json으로 되어있는 데이터를 struct로 변경, 즉 디코딩/데이터 파싱
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: jsonData)
                    print("todoResponse : \(baseResponse)")
                    
                    completion(.success(baseResponse))
                } catch {
                    completion(.failure(ApiError.decodingError))
                }
            }
        }.resume()
        
        
    }
    
    
    /// 할 일 삭제하기 - DELETE
    /// - Parameters:
    ///   - id: 수정할 아이템 아이디
    static func deleteATodo(
        id: Int,
        completion: @escaping (Result<BaseResponse<Todo>, ApiError>) -> Void
    ) {
        
        print(#fileID, #function, #line, "- deleteATodo 호출됨 / id : \(id)")
        
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos/\(id)"
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(ApiError.notAllowedUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")

        
        // 2. urlSession으로 API를 호출한다.
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, err in
            
            // 3. API 호출에 대한 응답을 받는다.
            // print("data : \(data)")
            // print("urlResponse : \(urlResponse)")
            // print("err : \(err)")
            
            if let error = err {
                return completion(.failure(ApiError.unknown(error)))
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                return completion(.failure(ApiError.unknown(nil)))
            }
            
            switch httpResponse.statusCode {
            case 401:
                return completion(.failure(ApiError.unauthorized))
            case 204:
                return completion(.failure(ApiError.noContent))
            default: print("default")
            }
            
            if  !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                do {
                    // json으로 되어있는 데이터를 struct로 변경, 즉 디코딩/데이터 파싱
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: jsonData)
                    print("todoResponse : \(baseResponse)")
                    
                    completion(.success(baseResponse))
                } catch {
                    completion(.failure(ApiError.decodingError))
                }
            }
        }.resume()
    }
    
    
    /// 할 일 추가 후 모든 할 일 불러오기
    /// - Parameters:
    ///   - title: 추가할 제목
    ///   - isDone: 완료 여부
    ///   - completion: 응답 결과
    static func addTodoAndFetchTodos(
        title: String,
        isDone: Bool = false,
        completion: @escaping (Result<BaseListResponse<Todo>, ApiError>) -> Void
    ) {
        // 1
        self.addATodo(title: title, completion: { result in
            switch result {
            // 1-1
            case .success(_):
                // 2
                self.fetchTodos(completion: {
                    switch $0 {
                    // 2-1
                    case .success(let data):
                        // 매개변수로 받은 completion
                        completion(.success(data))
                    // 2-2
                    case .failure(let failure):
                        // 매개변수로 받은 completion
                        completion(.failure(failure))
                    }
                })
            // 1-2
            case .failure(let failure):
                // 매개변수로 받은 completion
                completion(.failure(failure))
            }
        })
    }
    
    
    
    /// 클로저 기반 선택된 할 일들 삭제하기
    /// 동시에 처리
    /// - Parameters:
    ///   - seletedTodoIds: 선택된 할 일 아이디
    ///   - completion: 실제 삭제가 완료된 아이디들
    static func deleteSeletedTodos(
        seletedTodoIds: [Int],
        completion: @escaping ([Int]) -> Void
    ) {
        let group = DispatchGroup()
        var deletedTodoIds : [Int] = []
        
        seletedTodoIds.forEach { aTodoId in
            
            group.enter()
            
            self.deleteATodo(id: aTodoId, completion: { result in
                switch result {
                case .success(let response):
                    // 삭제된 아이디를 삭제된 아이디 배열에 넣는다.
                    if let todoId = response.data?.id {
                        deletedTodoIds.append(todoId)
                    }
                case .failure(let failure):
                    print("inner deleteATodo - failure: \(failure)")
                }
                
                group.leave()
            })
        }
        
        group.notify(queue: .main) {
            print("모든 API 완료됨")
            completion(deletedTodoIds)
        }
    }
    
    
    /// 클로저 기반 선택된 할 일들 가져오기
    /// 동시에 처리
    /// - Parameters:
    ///   - seletedTodoIds: 선택된 할 일 아이디
    ///   - completion: 응답결과
    static func fetchSeletedTodos(
        seletedTodoIds: [Int],
        completion: @escaping (Result<[Todo], ApiError>) -> Void
    ) {
        
        let group = DispatchGroup()
        
        // 가져온 할 일들
        var fetchedTodos : [Todo] = []
        // 에러가 난 것들
        var apiErrors : [ApiError] = []
        // 응답 결과들
        // var apiResults = [Int : Result<BaseResponse<Todo>, ApiError>]()
        
        seletedTodoIds.forEach { aTodoId in
            
            group.enter()
            
            self.fetchATodo(id: aTodoId, completion: { result in
                switch result {
                case .success(let response):
                    // 가져온 할 일을 가져온 할 일 배열에 넣는다.
                    if let todo = response.data {
                        fetchedTodos.append(todo)
                        print("inner fetchATodo - success: \(todo)")
                    }
                case .failure(let failure):
                    apiErrors.append(failure)
                    print("inner deleteATodo - failure: \(failure)")
                }
                
                group.leave()
            })
        }
        
        group.notify(queue: .main) {
            print("모든 API 완료됨")
            
            // 만약 에러가 있다면 에러 올려주기
            if !apiErrors.isEmpty {
                if let firstError = apiErrors.first {
                    completion(.failure(firstError))
                    return
                }
            }
            
            completion(.success(fetchedTodos))
        }
    }
    
    
    static func editATodoAndFetchATodo(id: Int,
                                       title:String,
                                       isDone:Bool=false,
                                       completion: @escaping (Result<BaseResponse<Todo>, ApiError>)-> Void) {
        self.editATodo(id: id, title: title, completion: { result in
            switch result {
            case .success(_):
                self.fetchATodo(id: id, completion: {
                    switch $0 {
                    case .success(let data):
                        completion(.success(data))
                    case .failure(let failure):
                        completion(.failure(failure))
                    }
                })
            case .failure(let failure):
                completion(.failure(failure))
            }
        })
    }
}

//MARK: - Closure -> Async
extension TodosAPI {
    /// 에러 처리 X - result
    /// Closure -> Async
    static func fetchTodosClosureToAsync(page: Int = 1) async -> Result<BaseListResponse<Todo>, ApiError> {
        return await withCheckedContinuation { (continuation : CheckedContinuation<Result<BaseListResponse<Todo>, ApiError>, Never>) in
            
            fetchTodos(page: page) { (result : Result<BaseListResponse<Todo>, ApiError>) in
                continuation.resume(returning: result)
            }
        }
    }
    
    /// 에러 처리 X - [Todo]
    /// Closure -> Async
    static func fetchTodosClosureToAsyncReturnArray(page: Int = 1) async -> [Todo] {
        return await withCheckedContinuation { (continuation : CheckedContinuation<[Todo], Never>) in
            
            fetchTodos(page: page) { (result : Result<BaseListResponse<Todo>, ApiError>) in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success.data ?? [])
                case .failure(_):
                    continuation.resume(returning: [])
                }
            }
        }
    }
    
    /// 에러 처리 O - result
    /// Closure -> Async
    static func fetchTodosClosureToAsyncWithError(page: Int = 1) async throws -> BaseListResponse<Todo> {
        return try await withCheckedThrowingContinuation({ (continuation : CheckedContinuation<BaseListResponse<Todo>, Error>) in
            fetchTodos(page: page) { (result : Result<BaseListResponse<Todo>, ApiError>) in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        })
    }
    
    /// 에러 처리 O - Error 형태 변경
    /// Closure -> Async
    static func fetchTodosClosureToAsyncWithMapError(page: Int = 1) async throws -> BaseListResponse<Todo> {
        return try await withCheckedThrowingContinuation({ (continuation : CheckedContinuation<BaseListResponse<Todo>, Error>) in
            fetchTodos(page: page) { (result : Result<BaseListResponse<Todo>, ApiError>) in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success)
                case .failure(let failure):
                    
                    if let decodingErr = failure as? DecodingError {
                        continuation.resume(throwing: ApiError.decodingError)
                        return
                    }
                    
                    continuation.resume(throwing: failure)
                }
            }
        })
    }
    
    /// 특정 할 일 목록 가져오기 - Error O
    /// Closure -> Async
    static func fetchATodoClosureToAsyncWithError(id: Int) async throws -> BaseResponse<Todo> {
        return try await withCheckedThrowingContinuation({ (continuation : CheckedContinuation<BaseResponse<Todo>, Error>) in
            fetchATodo(id: id, completion: { result in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            })
        })
    }
    
    /// 특정 할 일 목록 가져오기 - Error X
    /// Closure -> Async
    static func fetchATodoClosureToAsyncWithNoError(id: Int) async -> BaseResponse<Todo>? {
        return await withCheckedContinuation({ (continuation : CheckedContinuation<BaseResponse<Todo>?, Never>) in
            fetchATodo(id: id, completion: { result in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success)
                case .failure(_):
                    continuation.resume(returning: nil)
                }
            })
        })
    }
    
    /// 특정 할 일 목록 가져오기 - Error O 오류 형태 변경
    /// Closure -> Async
    static func fetchATodoClosureToAsyncWithMapError(id: Int) async throws -> BaseResponse<Todo> {
        return try await withCheckedThrowingContinuation({ (continuation : CheckedContinuation<BaseResponse<Todo>, Error>) in
            fetchATodo(id: id, completion: { result in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success)
                case .failure(let failure):
                    
                    if let decodingErr = failure as? DecodingError {
                        continuation.resume(throwing: ApiError.decodingError)
                        return
                    }
                    
                    continuation.resume(throwing: failure)
                }
            })
        })
    }
}

//MARK: - Closure -> Rx
extension TodosAPI {
    /// Closure -> Rx
    /// Error 처리 X - result
    static func fetchTodosClosureToObservable(page: Int = 1) -> Observable<Result<BaseListResponse<Todo>, ApiError>> {
        return Observable.create { (observer : AnyObserver<Result<BaseListResponse<Todo>, ApiError>>) in
            fetchTodos(page: page, completion: { result in
                observer.onNext(result)
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    /// Closure -> Rx
    /// Error 처리 X - 오류시 빈 배열 반환([])
    static func fetchTodosClosureToObservableDataArray(page: Int = 1) -> Observable<[Todo]> {
        return Observable.create { (observer : AnyObserver<BaseListResponse<Todo>>) in
            fetchTodos(page: page, completion: { result in
                switch result {
                case .success(let success):
                    observer.onNext(success)
                    observer.onCompleted()
                case .failure(let failure):
                    observer.onError(failure)
                    // onError는 Error가 나가면서 자동으로 complete 된다.
                }
            })
            return Disposables.create()
        }
            .map { $0.data ?? [] }
//            .catch { err in
//                return Observable.just([])
//            }
            .catchAndReturn([])
    }
    
    /// Closure -> Rx
    /// Error 처리 O
    static func fetchTodosClosureToObservableWithError(page: Int = 1) -> Observable<BaseListResponse<Todo>> {
        return Observable.create { (observer : AnyObserver<BaseListResponse<Todo>>) in
            fetchTodos(page: page, completion: { result in
                switch result {
                case .success(let success):
                    observer.onNext(success)
                    observer.onCompleted()
                case .failure(let failure):
                    observer.onError(failure)
                    // onError는 Error가 나가면서 자동으로 complete 된다.
                }
            })
            return Disposables.create()
        }
    }
    
    /// Closure -> Rx
    /// Error 처리 O - Error 형태 변경
    static func fetchTodosClosureToObservableWithMapError(page: Int = 1) -> Observable<BaseListResponse<Todo>> {
        return Observable.create { (observer : AnyObserver<BaseListResponse<Todo>>) in
            fetchTodos(page: page, completion: { result in
                switch result {
                case .success(let success):
                    observer.onNext(success)
                    observer.onCompleted()
                case .failure(let failure):
                    observer.onError(failure)
                    // onError는 Error가 나가면서 자동으로 complete 된다.
                }
            })
            return Disposables.create()
        }.catch { failure in
            // Rx에서 오류를 처리할 때는 catch를 통해 에러를 잡아내는 방식으로 처리해도 된다.
            // 물론 case .failure 내에서 Error를 구분해서 처리할 수도 있다.
            if failure is ApiError {
                throw ApiError.unauthorized
            }
            
            throw failure
        }
    }
    
    
    static func fetchATodoClosureToObservableNoError(id: Int) -> Observable<Todo> {
        // AnyObserver 부분에 내 마음대로 커스텀해도 되지만 일단 BaseResponse<Todo>가 들어온다고 우선 가정한다.
        return Observable.create { (observer: AnyObserver<BaseResponse<Todo>>) in
            fetchATodo(id: id, completion: { result in
                switch result {
                case .success(let data):
                    observer.onNext(data)
                    observer.onCompleted()
                case .failure(let failure):
                    observer.onError(failure)
                }
            })
            return Disposables.create()
        }.compactMap { response in
            guard let _ = response.data else {
                throw ApiError.noContent
            }
            return response.data
        }
    }
}

//MARK: - Closure -> Combine
extension TodosAPI {
    /// 오류 처리 O
    static func fetchTodosClosureToPublisherWithError(page: Int = 1) -> AnyPublisher<BaseListResponse<Todo>, ApiError> {
        return Future { (promise: @escaping (Result<BaseListResponse<Todo>, ApiError>) -> Void) in
            
            fetchTodos(page: page, completion: {result in
//                switch result {
//                case .success(let data):
//                    promise(.success(data))
//                case .failure(let failure):
//                    promise(.failure(failure))
//                }
                promise(result)
            })
        }.eraseToAnyPublisher()
    }
    
    /// 오류 처리 O - 오류 형태 변경
    static func fetchTodosClosureToPublisherMapError(page: Int = 1) -> AnyPublisher<BaseListResponse<Todo>, ApiError> {
        return Future { (promise: @escaping (Result<BaseListResponse<Todo>, ApiError>) -> Void) in
            
            fetchTodos(page: page, completion: {result in
                promise(result)
            })
        }.mapError({ err in
            if let urlErr = err as? ApiError {
                return ApiError.unauthorized
            }
            return err
        })
        .eraseToAnyPublisher()
    }
    
    /// 오류 처리 X
    static func fetchTodosClosureToPublisherWithNoError(page: Int = 1) -> AnyPublisher<[Todo], Never> {
        return Future { (promise: @escaping (Result<[Todo], Never>) -> Void) in
            
            fetchTodos(page: page, completion: {result in
                switch result {
                case .success(let data):
                    promise(.success(data.data ?? []))
                case .failure(_):
                    promise(.success([]))
                }
            })
        }.eraseToAnyPublisher()
    }
    
    /// 오류 처리 X - 빈 배열 반환 ([])
    static func fetchTodosClosureToPublisherReturnArray(page: Int = 1) -> AnyPublisher<[Todo], Never> {
        return Future { (promise: @escaping (Result<BaseListResponse<Todo>, ApiError>) -> Void) in
            fetchTodos(page: page, completion: {result in
                promise(result)
            })
        }
        .map { $0.data ?? [] }
//        .catch({ err in
//            return Just([])
//        })
        .replaceError(with: [])
        .eraseToAnyPublisher()
    }
    
    static func fetchATodoClosureToPublisher(id: Int) -> AnyPublisher<Todo?, Never> {
        return Future { (promise : @escaping (Result<BaseResponse<Todo>, ApiError>) -> Void) in
            fetchATodo(id: id, completion: {promise($0)})
        }
        .map { $0.data }
        .replaceError(with: nil)
        .eraseToAnyPublisher()
    }
}
