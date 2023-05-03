//
//  TodosAPI+Closure.swift
//  TodoAppTutorial
//
//  Created by Sudon Noh on 2023/05/03.
//

import Foundation
import MultipartForm


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
}
