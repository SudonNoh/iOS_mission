import Foundation
import MultipartForm
import RxSwift
import RxCocoa


extension TodosAPI {
    
    /// 모든 할 일 목록 가져오기
    static func fetchTodosWithObservableResult(
        page: Int = 1) ->
        Observable<Result<BaseListResponse<Todo>, ApiError>>
    {
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos" + "?page=\(page)"
        
        guard let url = URL(string: urlString) else {
            return Observable.just(.failure(ApiError.notAllowedUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다.
        // rx.response 에서 나오는 결과값을 Observable로 만들어서 나가기 때문에 아래 클로저에서는
        // Result를 반환하면 자동으로 Result를 감싼 옵저버블 형태로 반환된다.
        return URLSession.shared.rx.response(request: urlRequest)
            .map({ (urlResponse: HTTPURLResponse, data: Data) -> Result<BaseListResponse<Todo>, ApiError> in
                
                print("data: \(data)")
                print("urlResponse: \(urlResponse)")
                
                switch urlResponse.statusCode {
                case 401:
                    return .failure(ApiError.unauthorized)
                default: print("default")
                }
                
                if  !(200...299).contains(urlResponse.statusCode) {
                    return .failure(ApiError.badStatus(code: urlResponse.statusCode))
                }
                
                do {
                    // json으로 되어있는 데이터를 struct로 변경, 즉 디코딩/데이터 파싱
                    let listResponse = try JSONDecoder().decode(BaseListResponse<Todo>.self, from: data)
                    let todos = listResponse.data
                    print("todosResponse : \(listResponse)")
                    
                    // 상태 코드는 200인데, 파싱한 데이터에 따라서 에러처리가 되는 경우
                    guard let todos = todos,
                          !todos.isEmpty else {
                        return .failure(ApiError.noContent)
                    }
                    
                    return .success(listResponse)
                } catch {
                    return .failure(ApiError.decodingError)
                }
            })
    }
    
    
    // 반환 방식을 변경
    // observable error를 통해 error를 보낸다.
    static func fetchTodosWithObservable(
        page: Int = 1) ->
        Observable<BaseListResponse<Todo>>
    {
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos" + "?page=\(page)"
        
        guard let url = URL(string: urlString) else {
            // 에러를 던진다.
            return Observable.error(ApiError.notAllowedUrl)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다.
        // rx.response 에서 나오는 결과값을 Observable로 만들어서 나가기 때문에 아래 클로저에서는
        // Result를 반환하면 자동으로 Result를 감싼 옵저버블 형태로 반환된다.
        return URLSession.shared.rx.response(request: urlRequest)
            .map({ (urlResponse: HTTPURLResponse, data: Data) -> BaseListResponse<Todo> in
                // rx Observable 스코프 내부
                print("data: \(data)")
                print("urlResponse: \(urlResponse)")
                
                switch urlResponse.statusCode {
                case 401:
                    // Error가 나면 어차피 옵저버블 스코프를 탈출하기 때문에 return할 때 throw 해준다.
                    throw ApiError.unauthorized
                default: print("default")
                }
                
                if  !(200...299).contains(urlResponse.statusCode) {
                    throw ApiError.badStatus(code: urlResponse.statusCode)
                }
                
                do {
                    // json으로 되어있는 데이터를 struct로 변경, 즉 디코딩/데이터 파싱
                    let listResponse = try JSONDecoder().decode(BaseListResponse<Todo>.self, from: data)
                    let todos = listResponse.data
                    print("todosResponse : \(listResponse)")
                    
                    // 상태 코드는 200인데, 파싱한 데이터에 따라서 에러처리가 되는 경우
                    guard let todos = todos,
                          !todos.isEmpty else {
                        throw ApiError.noContent
                    }
                    
                    return listResponse
                } catch {
                    throw ApiError.decodingError
                }
            }
        )
    }
    
    
    /// 특정 할 일 목록 가져오기
    static func fetchATodoWithObservable(
        id: Int) ->
        Observable<BaseResponse<Todo>>
    {
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos" + "/\(id)"
        
        guard let url = URL(string: urlString) else {
            return Observable.error(ApiError.notAllowedUrl)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다.
        return URLSession.shared.rx.response(request: urlRequest)
            .map({ (urlResponse: HTTPURLResponse, data: Data) -> BaseResponse<Todo> in
                
                switch urlResponse.statusCode {
                case 401:
                    throw ApiError.unauthorized
                case 204:
                    throw ApiError.noContent
                default: print("default")
                }
                
                if  !(200...299).contains(urlResponse.statusCode) {
                    throw ApiError.badStatus(code: urlResponse.statusCode)
                }
                do {
                    // json으로 되어있는 데이터를 struct로 변경, 즉 디코딩/데이터 파싱
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
                    print("todoResponse : \(baseResponse)")
                    
                    return baseResponse
                } catch {
                    throw ApiError.decodingError
                }
            }
        )
    }
    
    
    /// 할 일 검색하기
    static func searchTodosWithObservable(
        searchTerm: String,
        page: Int = 1) ->
        Observable<BaseListResponse<Todo>>
    {
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
            return Observable.error(ApiError.notAllowedUrl)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다.
        return URLSession.shared.rx.response(request: urlRequest)
            .map({ (urlResponse: HTTPURLResponse, data: Data) -> BaseListResponse<Todo> in
                switch urlResponse.statusCode {
                case 401:
                    throw ApiError.unauthorized
                case 204:
                    throw ApiError.noContent
                default: print("default")
                }
                
                if  !(200...299).contains(urlResponse.statusCode) {
                    throw ApiError.badStatus(code: urlResponse.statusCode)
                }
                
                do {
                    // json으로 되어있는 데이터를 struct로 변경, 즉 디코딩/데이터 파싱
                    let listResponse = try JSONDecoder().decode(BaseListResponse<Todo>.self, from: data)
                    let todos = listResponse.data
                    print("todosResponse : \(listResponse)")
                    
                    // 상태 코드는 200인데, 파싱한 데이터에 따라서 에러처리가 되는 경우
                    guard let todos = todos,
                          !todos.isEmpty else {
                        throw ApiError.noContent
                    }
                    
                    return listResponse
                } catch {
                    throw ApiError.decodingError
                }
            })}
    
    
    /// 할 일 추가하기
    /// - Parameters:
    ///   - title: 할 일 타이틀
    ///   - isDone: 할 일 완료 여부
    ///   - completion: 응답 결과
    static func addATodoWithObservable(
        title: String,
        isDone: Bool = false) ->
        Observable<BaseResponse<Todo>>
    {
        
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos"
        
        guard let url = URL(string: urlString) else {
            return Observable.error(ApiError.notAllowedUrl)
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
        return URLSession.shared.rx.response(request: urlRequest)
            .map({(urlResponse: HTTPURLResponse, data: Data) -> BaseResponse<Todo> in
                switch urlResponse.statusCode {
                case 401:
                    throw ApiError.unauthorized
                case 204:
                    throw ApiError.noContent
                default: print("default")
                }
                
                if  !(200...299).contains(urlResponse.statusCode) {
                    throw ApiError.badStatus(code: urlResponse.statusCode)
                }
                
                do {
                    // json으로 되어있는 데이터를 struct로 변경, 즉 디코딩/데이터 파싱
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
                    print("todoResponse : \(baseResponse)")
                    
                    return baseResponse
                } catch {
                    throw ApiError.decodingError
                }
            }
        )
    }
    
    
    /// 할 일 추가하기(JSON)
    /// - Parameters:
    ///   - title: 할 일 타이틀
    ///   - isDone: 할 일 완료 여부
    ///   - completion: 응답 결과
    static func addATodoJSONWithObservable(
        title: String,
        isDone: Bool = false) ->
        Observable<BaseResponse<Todo>>
    {
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos-json"
        
        guard let url = URL(string: urlString) else {
            return Observable.error(ApiError.notAllowedUrl)
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
            return Observable.error(ApiError.jsonEncodingError)
        }
        
        // 2. urlSession으로 API를 호출한다.
        // URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, err in
        return URLSession.shared.rx.response(request: urlRequest)
            .map({ (urlResponse: HTTPURLResponse, data: Data) -> BaseResponse<Todo> in
                
                switch urlResponse.statusCode {
                case 401:
                    throw ApiError.unauthorized
                case 204:
                    throw ApiError.noContent
                default: print("default")
                }
                
                if  !(200...299).contains(urlResponse.statusCode) {
                    throw ApiError.badStatus(code: urlResponse.statusCode)
                }
                
                do {
                    // json으로 되어있는 데이터를 struct로 변경, 즉 디코딩/데이터 파싱
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
                    print("todoResponse : \(baseResponse)")
                    
                    return baseResponse
                } catch {
                    throw ApiError.decodingError
                }
            }
        )
    }
    
    
    /// 할 일 수정하기
    /// - Parameters:
    ///   - id: 수정할 아이템 아이디
    ///   - title: 할 일 타이틀
    ///   - isDone: 할 일 완료 여부
    ///   - completion: 응답 결과
    static func editTodoJsonWithObservable(
        id: Int,
        title: String,
        isDone: Bool = false) ->
        Observable<BaseResponse<Todo>>
    {
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos-json/\(id)"
        
        guard let url = URL(string: urlString) else {
            return Observable.error(ApiError.notAllowedUrl)
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
            return Observable.error(ApiError.jsonEncodingError)
        }
        
        // 2. urlSession으로 API를 호출한다.
        // URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, err in
        return URLSession.shared.rx.response(request: urlRequest)
            .map({(urlResponse: HTTPURLResponse, data:Data) -> BaseResponse<Todo> in
                
                switch urlResponse.statusCode {
                case 401:
                    throw ApiError.unauthorized
                case 204:
                    throw ApiError.noContent
                default: print("default")
                }
                
                if  !(200...299).contains(urlResponse.statusCode) {
                    throw ApiError.badStatus(code: urlResponse.statusCode)
                }
                
                do {
                    // json으로 되어있는 데이터를 struct로 변경, 즉 디코딩/데이터 파싱
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
                    print("todoResponse : \(baseResponse)")
                    
                    return baseResponse
                } catch {
                    throw ApiError.decodingError
                }
            }
        )
    }
    
    
    /// 할 일 수정하기 - PUT urlEncoded
    /// - Parameters:
    ///   - id: 삭제할 아이템 아이디
    ///   - title: 할 일 타이틀
    ///   - isDone: 할 일 완료 여부
    ///   - completion: 응답 결과
    static func editATodoWithObservable(
        id: Int,
        title: String,
        isDone: Bool = false) ->
        Observable<BaseResponse<Todo>>
    {
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos/\(id)"
        
        guard let url = URL(string: urlString) else {
            return Observable.error(ApiError.notAllowedUrl)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let requestParams : [String : String] = ["title":title, "is_done":"\(isDone)"]
        
        urlRequest.percentEncodeParameters(parameters: requestParams)
        
        // 2. urlSession으로 API를 호출한다.
        return URLSession.shared.rx.response(request: urlRequest)
            .map({(urlResponse: HTTPURLResponse, data: Data) -> BaseResponse<Todo> in
                switch urlResponse.statusCode {
                case 401:
                    throw ApiError.unauthorized
                case 204:
                    throw ApiError.noContent
                default: print("default")
                }
                
                if  !(200...299).contains(urlResponse.statusCode) {
                    throw ApiError.badStatus(code: urlResponse.statusCode)
                }
                
                do {
                    // json으로 되어있는 데이터를 struct로 변경, 즉 디코딩/데이터 파싱
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
                    print("todoResponse : \(baseResponse)")
                    
                    return baseResponse
                } catch {
                    throw ApiError.decodingError
                }
            }
        )
    }
    
    
    /// 할 일 삭제하기 - DELETE
    /// - Parameters:
    ///   - id: 수정할 아이템 아이디
    static func deleteATodoWithObservable(id: Int) ->
        Observable<BaseResponse<Todo>>
    {
        print(#fileID, #function, #line, "- deleteATodo 호출됨 / id : \(id)")
        
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos/\(id)"
        
        guard let url = URL(string: urlString) else {
            return Observable.error(ApiError.notAllowedUrl)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")

        
        // 2. urlSession으로 API를 호출한다.
        // URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, err in
        return URLSession.shared.rx.response(request: urlRequest)
            .map({(urlResponse: HTTPURLResponse, data: Data) -> BaseResponse<Todo> in
                switch urlResponse.statusCode {
                case 401:
                    throw ApiError.unauthorized
                case 204:
                    throw ApiError.noContent
                default: print("default")
                }
                
                if  !(200...299).contains(urlResponse.statusCode) {
                    throw ApiError.badStatus(code: urlResponse.statusCode)
                }
                
                do {
                    // json으로 되어있는 데이터를 struct로 변경, 즉 디코딩/데이터 파싱
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
                    print("todoResponse : \(baseResponse)")
                    
                    return baseResponse
                } catch {
                    throw ApiError.decodingError
                }
            }
        )
    }
    
    
    /// 할 일 추가 후 모든 할 일 불러오기
    /// - Parameters:
    ///   - title: 추가할 제목
    ///   - isDone: 완료 여부
    ///   - completion: 응답 결과
    static func addTodoAndFetchTodosWithObservable(
        title: String,
        isDone: Bool = false) ->
        Observable<BaseListResponse<Todo>>
    {
        return self.addATodoWithObservable(title: title)
                    // flatMapLatest 첫번째 호출했던 API의 응답 결과가 response: BaseResponse<Todo>로 들어가게 된다.
                    // .flatMapLatest { (response: BaseResponse<Todo>) in self.fetchTodosWithObservable() }
                    .flatMapLatest { _ in self.fetchTodosWithObservable() }
                    .share(replay: 1)
    }
    
    static func addTodoAndFetchTodosWithObservable2(
        title: String,
        isDone: Bool = false) ->
        Observable<[Todo]>
    {
        return self.addATodoWithObservable(title: title)
                    .flatMapLatest { _ in self.fetchTodosWithObservable() } // 여기까지는 Observable<BaseResponse<Todo>>
                    .compactMap{ $0.data } // 여기서 [Todo] 로 바뀐다.
                    .catch({ err in
                        print(#fileID, #function, #line, "- err: \(err)")
                        return Observable.just([])
                    })
                    .share(replay: 1)
    }
    
    
    
    /// 클로저 기반 선택된 할 일들 삭제하기
    /// 동시에 처리
    /// - Parameters:
    ///   - seletedTodoIds: 선택된 할 일 아이디
    ///   - completion: 실제 삭제가 완료된 아이디들
    static func deleteSeletedTodosWithObservable(seletedTodoIds: [Int]) -> Observable<[Int]> {
        // 매개변수 배열 -> Observable 스트림 배열로 만든다.
        // 배열로 단일 api 호출
        let apiCallObservables = seletedTodoIds.map { id -> Observable<Int?> in
            return self.deleteATodoWithObservable(id: id)
                .map{ $0.data?.id } // Int?
                .catchAndReturn(nil)
//                .catch { err in
//                    return Observable.just(nil)
//                }
        }
        
        return Observable.zip(apiCallObservables) // Observable<[Int?]>
            .map { $0.compactMap{ $0 }} // Observable<[Int]>
    }
    
    static func deleteSeletedTodosWithObservableMerge(seletedTodoIds: [Int]) -> Observable<Int> {
        // 매개변수 배열 -> Observable 스트림 배열로 만든다.
        // 배열로 단일 api 호출
        let apiCallObservables = seletedTodoIds.map { id -> Observable<Int?> in
            return self.deleteATodoWithObservable(id: id)
                .map{ $0.data?.id } // Int?
                .catchAndReturn(nil)
//                .catch { err in
//                    return Observable.just(nil)
//                }
        }
        
        return Observable.merge(apiCallObservables).compactMap{ $0 }
    }
    
    /// 클로저 기반 선택된 할 일들 가져오기
    /// 동시에 처리
    /// - Parameters:
    ///   - seletedTodoIds: 선택된 할 일 아이디
    ///   - completion: 응답결과
    static func fetchSeletedTodosWithObservable( seletedTodoIds: [Int] ) -> Observable<[Todo]> {
        
        let apiCallObservables = seletedTodoIds.map { id -> Observable<Todo?> in
            return self.fetchATodoWithObservable(id: id)
                .map { $0.data } // Todo?
                .catchAndReturn(nil)
        }
        
        return Observable.zip(apiCallObservables)
            .map{ $0.compactMap { $0 }}
    }
    
    static func fetchSeletedTodosWithObservableMerge( seletedTodoIds: [Int] ) -> Observable<Todo> {
        let apiCallObservables = seletedTodoIds.map { id -> Observable<Todo?> in
            return self.fetchATodoWithObservable(id: id)
                .map { $0.data } // Todo?
                .catchAndReturn(nil)
        }
        
        return Observable.merge(apiCallObservables)
            .compactMap { $0 }
    }
}
