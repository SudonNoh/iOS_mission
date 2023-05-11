import Foundation
import MultipartForm
import Combine
import CombineExt


extension TodosAPI {
    
    /// 모든 할 일 목록 가져오기
    /// Result로 반환할 때
    /// 이벤트를 한 번 보내려면 Just를 사용해서 보낸다.
    static func fetchTodosWithPublisherResult(
        page: Int = 1) ->
        AnyPublisher<Result<BaseListResponse<Todo>, ApiError>, Never>
    {
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos" + "?page=\(page)"
        
        guard let url = URL(string: urlString) else {
            // eraseToAnyPublisher 는 Publisher 형태의 Just 결과값을 AnyPublisher 형태로 변환해서 반환한다.
            return Just(.failure(ApiError.notAllowedUrl)).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다.
        // rx.response 에서 나오는 결과값을 Observable로 만들어서 나가기 때문에 아래 클로저에서는
        // Result를 반환하면 자동으로 Result를 감싼 옵저버블 형태로 반환된다.
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map({ (data: Data, urlResponse: URLResponse) -> Result<BaseListResponse<Todo>, ApiError> in
                print("data: \(data)")
                print("urlResponse: \(urlResponse)")
                
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    print("bad status code")
                    return .failure(ApiError.unknown(nil))
                }
                
                switch httpResponse.statusCode {
                case 401:
                    return .failure(ApiError.unauthorized)
                default: print("default")
                }
                
                if  !(200...299).contains(httpResponse.statusCode) {
                    return .failure(ApiError.badStatus(code: httpResponse.statusCode))
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
//            .catch({ err in
//                return Just(.failure(ApiError.unknown(nil))
//            })
            .replaceError(with: .failure(ApiError.unknown(nil)))
            // .assertNoFailure() // Err가 나지않겠다고 선언하는 방법
            .eraseToAnyPublisher()
    }
    
    
    // 반환 방식을 변경
    // observable error를 통해 error를 보낸다.
    static func fetchTodosWithPublisher(
        page: Int = 1) ->
        AnyPublisher<BaseListResponse<Todo>, ApiError>
    {
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos" + "?page=\(page)"
        
        guard let url = URL(string: urlString) else {
            // 에러를 던진다.
            // 스트림 종료
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다.
        // rx.response 에서 나오는 결과값을 Observable로 만들어서 나가기 때문에 아래 클로저에서는
        // Result를 반환하면 자동으로 Result를 감싼 옵저버블 형태로 반환된다.
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            // Error를 던질 경우 tryMap을 활용한다. Never가 아닌 경우
            // .tryMap ({ (data: Data, urlResponse: URLResponse) -> BaseListResponse<Todo> in
            // try붙은 메소드의 경우 에러를 던질 수 있다.
            .tryMap ({ (data: Data, urlResponse: URLResponse) -> Data in
                
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    print("bad status code")
                    throw ApiError.unknown(nil)
                }
                
                switch httpResponse.statusCode {
                case 401:
                    // Error가 나면 어차피 옵저버블 스코프를 탈출하기 때문에 return할 때 throw 해준다.
                    throw ApiError.unauthorized
                default: print("default")
                }
                
                if  !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
                
//                do {
//                    // json으로 되어있는 데이터를 struct로 변경, 즉 디코딩/데이터 파싱
//                    let listResponse = try JSONDecoder().decode(BaseListResponse<Todo>.self, from: data)
//                    let todos = listResponse.data
//                    print("todosResponse : \(listResponse)")
//
//                    // 상태 코드는 200인데, 파싱한 데이터에 따라서 에러처리가 되는 경우
//                    guard let todos = todos,
//                          !todos.isEmpty else {
//                        throw ApiError.noContent
//                    }
//
//                    return listResponse
//                } catch {
//                    throw ApiError.decodingError
//                }

                return data
            })
            // JSON->Struct로 변경(디코딩, 데이터 파싱)
            // 디코딩처리
            .decode(type: BaseListResponse<Todo>.self, decoder: JSONDecoder())
            // 상태코드는 200인데, 파싱한 데이터에 따라서 에러처리
            .tryMap({ response in
                guard let todos = response.data,
                      !todos.isEmpty else { throw ApiError.noContent }
                return response
            })
            // mapError를 통하면 에러타입을 변경할 수 있다.
            .mapError({ err -> ApiError in
                if let error = err as? ApiError {
                    return error
                }
                
                if let decodingError = err as? DecodingError {
                    return ApiError.decodingError // 디코딩 에러라면
                }
                return ApiError.unknown(nil)
            })
            .eraseToAnyPublisher()
    }
    
    
    /// 특정 할 일 목록 가져오기
    static func fetchATodoWithPublisher(
        id: Int) ->
        AnyPublisher<BaseResponse<Todo>, ApiError>
    {
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos" + "/\(id)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다.
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap({ (data: Data, urlResponse: URLResponse) -> Data in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    print("bad status code")
                    throw ApiError.unknown(nil)
                }
                
                switch httpResponse.statusCode {
                case 401:
                    throw ApiError.unauthorized
                case 204:
                    throw ApiError.noContent
                default: print("default")
                }
                
                if  !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
                
                return data
            })
            .decode(type: BaseResponse<Todo>.self, decoder: JSONDecoder())
            .mapError { err -> ApiError in
                if let error = err as? ApiError {
                    return error
                }
                
                if let decodingError = err as? DecodingError {
                    return ApiError.decodingError
                }
                return ApiError.unknown(nil)
            }.eraseToAnyPublisher()
    }
    
    
    /// 할 일 검색하기
    static func searchTodosWithPublisher(
        searchTerm: String,
        page: Int = 1) ->
        AnyPublisher<BaseListResponse<Todo>, ApiError>
    {
        // 1. urlRequest를 만든다.
        
        let requestUrl = URL(baseUrl: baseURL + "/todos/search", queryItems: ["query" : searchTerm, "page" : "\(page)"])

        guard let url = requestUrl else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다.
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap({ (data: Data, urlResponse: URLResponse) -> Data in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    print("Bad status code")
                    throw ApiError.unknown(nil)
                }
                
                switch httpResponse.statusCode {
                case 401:
                    throw ApiError.unauthorized
                case 204:
                    throw ApiError.noContent
                default: print("default")
                }
                
                if  !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
                
                return data
            })
            .decode(type: BaseListResponse<Todo>.self, decoder: JSONDecoder())
            .tryMap({ response in
                guard let todos = response.data,
                      !todos.isEmpty else {
                    throw ApiError.noContent
                }
                return response
            })
            .mapError { err in
                if let error = err as? ApiError {
                    return error
                }
                
                if let decodingError = err as? DecodingError {
                    return ApiError.decodingError // 디코딩 에러라면
                }
                return ApiError.unknown(nil)
            }.eraseToAnyPublisher()
        
    }
    
    
    /// 할 일 추가하기
    /// - Parameters:
    ///   - title: 할 일 타이틀
    ///   - isDone: 할 일 완료 여부
    ///   - completion: 응답 결과
    static func addATodoWithPublisher(
        title: String,
        isDone: Bool = false) ->
        AnyPublisher<BaseResponse<Todo>, ApiError>
    {
        
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
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
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap({ (data: Data, urlResponse: URLResponse) -> Data in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    print("Bad status code")
                    throw ApiError.unknown(nil)
                }
                
                switch httpResponse.statusCode {
                case 401:
                    throw ApiError.unauthorized
                case 204:
                    throw ApiError.noContent
                default: print("default")
                }
                
                if  !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
                
                return data
            })
            .decode(type: BaseResponse<Todo>.self, decoder: JSONDecoder())
            .mapError { err -> ApiError in
                if let error = err as? ApiError {
                    return error
                }
                
                if let decodingError = err as? DecodingError {
                    return ApiError.decodingError // 디코딩 에러라면
                }
                return ApiError.unknown(nil)
            }.eraseToAnyPublisher()
    }
    
    
    /// 할 일 추가하기(JSON)
    /// - Parameters:
    ///   - title: 할 일 타이틀
    ///   - isDone: 할 일 완료 여부
    ///   - completion: 응답 결과
    static func addATodoJSONWithPublisher(
        title: String,
        isDone: Bool = false) ->
        AnyPublisher<BaseResponse<Todo>, ApiError>
    {
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos-json"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
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
            return Fail(error: ApiError.jsonEncodingError).eraseToAnyPublisher()
        }
        
        // 2. urlSession으로 API를 호출한다.
        // URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, err in
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap({ (data: Data, urlResponse: URLResponse) -> Data in
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    print("Bad status code")
                    throw ApiError.unknown(nil)
                }
                
                switch httpResponse.statusCode {
                case 401:
                    throw ApiError.unauthorized
                case 204:
                    throw ApiError.noContent
                default: print("default")
                }
                
                if  !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
                
                return data
            })
            .decode(type: BaseResponse<Todo>.self, decoder: JSONDecoder())
            .mapError { err -> ApiError in
                if let error = err as? ApiError {
                    return error
                }
                
                if let decodingError = err as? DecodingError {
                    return ApiError.decodingError // 디코딩 에러라면
                }
                return ApiError.unknown(nil)
            }.eraseToAnyPublisher()
    }
    
    
    /// 할 일 수정하기
    /// - Parameters:
    ///   - id: 수정할 아이템 아이디
    ///   - title: 할 일 타이틀
    ///   - isDone: 할 일 완료 여부
    ///   - completion: 응답 결과
    static func editTodoJsonWithPublisher(
        id: Int,
        title: String,
        isDone: Bool = false) ->
        AnyPublisher<BaseResponse<Todo>, ApiError>
    {
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos-json/\(id)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
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
            return Fail(error: ApiError.jsonEncodingError).eraseToAnyPublisher()
        }
        
        // 2. urlSession으로 API를 호출한다.
        // URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, err in
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, response: URLResponse) -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw ApiError.unknown(nil)
                }
                
                switch httpResponse.statusCode {
                case 401:
                    throw ApiError.unauthorized
                case 204:
                    throw ApiError.noContent
                default: print("default")
                }
                
                if  !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
                
                return data
            }
            .decode(type: BaseResponse<Todo>.self, decoder: JSONDecoder())
            .mapError { err in
                if let error = err as? ApiError {
                    return error
                }
                
                if let decodingError = err as? DecodingError {
                    return ApiError.decodingError // 디코딩 에러라면
                }
                return ApiError.unknown(nil)
            }.eraseToAnyPublisher()
    }
    
    
    /// 할 일 수정하기 - PUT urlEncoded
    /// - Parameters:
    ///   - id: 삭제할 아이템 아이디
    ///   - title: 할 일 타이틀
    ///   - isDone: 할 일 완료 여부
    ///   - completion: 응답 결과
    static func editATodoWithPublisher(
        id: Int,
        title: String,
        isDone: Bool = false) ->
        AnyPublisher<BaseResponse<Todo>, ApiError>
    {
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos/\(id)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error:ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let requestParams : [String : String] = ["title":title, "is_done":"\(isDone)"]
        
        urlRequest.percentEncodeParameters(parameters: requestParams)
        
        // 2. urlSession으로 API를 호출한다.
        // URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, err in
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, response: URLResponse) -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw ApiError.unknown(nil)
                }
                
                switch httpResponse.statusCode {
                case 401:
                    throw ApiError.unauthorized
                case 204:
                    throw ApiError.noContent
                default: print("default")
                }
                
                if  !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
                
                return data
            }
            .decode(type: BaseResponse<Todo>.self, decoder: JSONDecoder())
            .mapError { err in
                if let error = err as? ApiError {
                    return error
                }
                
                if let decodingError = err as? DecodingError {
                    return ApiError.decodingError // 디코딩 에러라면
                }
                return ApiError.unknown(nil)
            }.eraseToAnyPublisher()
    }
    
    
    /// 할 일 삭제하기 - DELETE
    /// - Parameters:
    ///   - id: 수정할 아이템 아이디
    static func deleteATodoWithPublisher(id: Int) ->
        AnyPublisher<BaseResponse<Todo>, ApiError>
    {
        print(#fileID, #function, #line, "- deleteATodo 호출됨 / id : \(id)")
        
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos/\(id)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowedUrl).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")

        
        // 2. urlSession으로 API를 호출한다.
        // URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, err in
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap({ (data: Data, response: URLResponse) -> Data in
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw ApiError.unknown(nil)
                }
                
                switch httpResponse.statusCode {
                case 401:
                    throw ApiError.unauthorized
                case 204:
                    throw ApiError.noContent
                default: print("default")
                }
                
                if  !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
                
                return data
            })
            .decode(type: BaseResponse<Todo>.self, decoder: JSONDecoder())
            .mapError { err in
                if let error = err as? ApiError {
                    return error
                }
                
                if let decodingError = err as? DecodingError {
                    return ApiError.decodingError // 디코딩 에러라면
                }
                return ApiError.unknown(nil)
            }.eraseToAnyPublisher()
    }
    
    
    /// 할 일 추가 후 모든 할 일 불러오기
    /// - Parameters:
    ///   - title: 추가할 제목
    ///   - isDone: 완료 여부
    ///   - completion: 응답 결과
    static func addTodoAndFetchTodosWithPublisher(
        title: String,
        isDone: Bool = false) ->
        AnyPublisher<[Todo], ApiError>
    {
        // 여기에서 에러처리를 따로 하지 않는 이유는 이미 addATodoWithPublisher와 fetchTodosWithPublisher에서
        // 에러처리가 되었기 때문이다.
        return self.addATodoWithPublisher(title: title)
                    .flatMap { _ in
                        self.fetchTodosWithPublisher()
                    } // BaseListResponse<Todo>
                    .compactMap { $0.data }
                    .eraseToAnyPublisher()
    }
    
    /// 할 일 추가 후 모든 할 일 불러오기 - No Error
    /// - Parameters:
    ///   - title: 추가할 제목
    ///   - isDone: 완료 여부
    ///   - completion: 응답 결과
    static func addTodoAndFetchTodosWithPublisherNoErr(
        title: String,
        isDone: Bool = false) ->
        AnyPublisher<[Todo], Never>
    {
        return self.addATodoWithPublisher(title: title)
                    .flatMap { _ in
                        self.fetchTodosWithPublisher()
                    } // BaseListResponse<Todo>
                    .compactMap { $0.data }
//                    .catch ({ err in
//                        return Just([]).eraseToAnyPublisher()
//                    })
                    .replaceError(with: [])
                    .eraseToAnyPublisher()
    }
    
    /// 할 일 추가 후 모든 할 일 불러오기 - No Error SwitchToLatest
    /// Rx의 flatMapLatest 는 map + switchToLatest로 구현이 가능하다.
    /// - Parameters:
    ///   - title: 추가할 제목
    ///   - isDone: 완료 여부
    ///   - completion: 응답 결과
    static func addTodoAndFetchTodosWithPublisherNoErrSwitchToLatest(
        title: String,
        isDone: Bool = false) ->
        AnyPublisher<[Todo], Never>
    {
        return self.addATodoWithPublisher(title: title)
                    .map { _ in
                        self.fetchTodosWithPublisher()
                    } // BaseListResponse<Todo>
                    .switchToLatest()
                    .compactMap { $0.data }
//                    .catch ({ err in
//                        return Just([]).eraseToAnyPublisher()
//                    })
                    .replaceError(with: [])
                    .eraseToAnyPublisher()
    }
    
    
    /// 클로저 기반 선택된 할 일들 삭제하기
    /// 동시에 처리
    /// - Parameters:
    ///   - seletedTodoIds: 선택된 할 일 아이디
    ///   - completion: 실제 삭제가 완료된 아이디들
    static func deleteSeletedTodosWithPublisherMerge(seletedTodoIds: [Int]) -> AnyPublisher<Int, Never> {
        // 매개변수 배열 -> Observable 스트림 배열로 만든다.
        // 배열로 단일 api 호출
        let apiCallPublishers = seletedTodoIds.map { id -> AnyPublisher<Int?, Never> in
            return self.deleteATodoWithPublisher(id: id)
                .map{ $0.data?.id } // Int?
                .replaceError(with: nil)
                .eraseToAnyPublisher()
        }
        
        return Publishers.MergeMany(apiCallPublishers).compactMap { $0 }.eraseToAnyPublisher()
    }
    
    static func deleteSeletedTodosWithPublisherMergeWithError(seletedTodoIds: [Int]) -> AnyPublisher<Int, ApiError> {
        // 매개변수 배열 -> Observable 스트림 배열로 만든다.
        // 배열로 단일 api 호출
        let apiCallPublishers = seletedTodoIds.map { id -> AnyPublisher<Int?, ApiError> in
            return self.deleteATodoWithPublisher(id: id)
                .map{ $0.data?.id } // Int?
                .eraseToAnyPublisher()
        }
        
        return Publishers.MergeMany(apiCallPublishers).compactMap { $0 }.eraseToAnyPublisher()
    }
    
    static func deleteSeletedTodosWithPublisherZip(seletedTodoIds: [Int]) -> AnyPublisher<[Int], Never> {
        // 매개변수 배열 -> Observable 스트림 배열로 만든다.
        // 배열로 단일 api 호출
        let apiCallPublishers : [AnyPublisher<Int?, Never>] = seletedTodoIds.map { id -> AnyPublisher<Int?, Never> in
            return self.deleteATodoWithPublisher(id: id)
                .map{ $0.data?.id } // Int?
                .replaceError(with: nil)
                .eraseToAnyPublisher()
        }
        
        return apiCallPublishers.zip().map { $0.compactMap{$0} }.eraseToAnyPublisher()
    }
    
    /// 클로저 기반 선택된 할 일들 가져오기
    /// 동시에 처리
    /// - Parameters:
    ///   - seletedTodoIds: 선택된 할 일 아이디
    ///   - completion: 응답결과
    static func fetchSeletedTodosWithPublisherZip( seletedTodoIds: [Int] ) -> AnyPublisher<[Todo], Never> {
        // AnyPublisher<BaseResponse<Todo>, ApiError>
        let apiCallPublisher = seletedTodoIds.map { id -> AnyPublisher<Todo?, Never> in
            return self.fetchATodoWithPublisher(id: id)
                .map { $0.data } // Todo?
                .replaceError(with: nil)
                .eraseToAnyPublisher()
        }
        return apiCallPublisher.zip().map{ $0.compactMap { $0 }}.eraseToAnyPublisher()
    }

    static func fetchSeletedTodosWithPublisherMerge( seletedTodoIds: [Int] ) -> AnyPublisher<Todo, Never> {
        // AnyPublisher<BaseResponse<Todo>, ApiError>
        let apiCallPublisher = seletedTodoIds.map { id -> AnyPublisher<Todo?, Never> in
            return self.fetchATodoWithPublisher(id: id)
                .map { $0.data } // Todo?
                .replaceError(with: nil)
                .eraseToAnyPublisher()
        }
        return Publishers.MergeMany(apiCallPublisher).compactMap{ $0 }.eraseToAnyPublisher()
    }
}
