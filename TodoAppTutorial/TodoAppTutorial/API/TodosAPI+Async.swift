import Foundation
import MultipartForm
import Combine
import CombineExt


extension TodosAPI {
    
    /// 모든 할 일 목록 가져오기
    /// Result로 반환할 때
    /// 이벤트를 한 번 보내려면 Just를 사용해서 보낸다.
    static func fetchTodosWithAsyncResult(
        page: Int = 1) async ->
        Result<BaseListResponse<Todo>, ApiError>
    {
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos" + "?page=\(page)"
        
        guard let url = URL(string: urlString) else {
            // eraseToAnyPublisher 는 Publisher 형태의 Just 결과값을 AnyPublisher 형태로 변환해서 반환한다.
            return .failure(ApiError.notAllowedUrl)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다.
        // Error가 들어온다면 do try catch 문을 써서 Error를 잡아준다.
        // Error를 따로 처리하지 않을 경우 try?를 사용해서 구문을 완성한다.
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            
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
            
            // do try catch 문으로 이미 구성되어 있기 때문에 do try catch 구문을 빼준다.
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
            if let _ = error as? DecodingError {
                return .failure(ApiError.decodingError)
            }
            return .failure(ApiError.unknown(error))
        }
    }
    
    
    // 반환 방식을 변경
    // observable error를 통해 error를 보낸다.
    static func fetchTodosWithAsync(
        page: Int = 1) async throws ->
        BaseListResponse<Todo>
    {
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos" + "?page=\(page)"
        
        guard let url = URL(string: urlString) else {
            // 에러를 던진다.
            // 스트림 종료
            throw ApiError.notAllowedUrl
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다.
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            
            print("data: \(data)")
            print("urlResponse: \(urlResponse)")
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                throw ApiError.unknown(nil)
            }
            
            switch httpResponse.statusCode {
            case 401:
                throw ApiError.unauthorized
            default: print("default")
            }
            
            if  !(200...299).contains(httpResponse.statusCode) {
               throw ApiError.badStatus(code: httpResponse.statusCode)
            }
            
            // do try catch 문으로 이미 구성되어 있기 때문에 do try catch 구문을 빼준다.
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
            if let apiError = error as? URLError {
                throw ApiError.badStatus(code: apiError.errorCode)
            }
            
            if let _ = error as? DecodingError {
                throw ApiError.decodingError
            }
            throw ApiError.unknown(error)
        }
    }
    
    
    /// 특정 할 일 목록 가져오기
    static func fetchATodoWithAsync(
        id: Int) async throws ->
        BaseResponse<Todo>
    {
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos" + "/\(id)"
        
        guard let url = URL(string: urlString) else {
            throw ApiError.notAllowedUrl
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            
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
            
            return try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
        } catch {
            if let apiError = error as? URLError {
                throw ApiError.badStatus(code: apiError.errorCode)
            }
            
            if let _ = error as? DecodingError {
                throw ApiError.decodingError
            }
            throw ApiError.unknown(error)
        }
    }
    
    
    /// 할 일 검색하기
    static func searchTodosWithAsync(
        searchTerm: String,
        page: Int = 1) async throws ->
        BaseListResponse<Todo>
    {
        // 1. urlRequest를 만든다.
        
        let requestUrl = URL(baseUrl: baseURL + "/todos/search", queryItems: ["query" : searchTerm, "page" : "\(page)"])

        guard let url = requestUrl else {
            throw ApiError.notAllowedUrl
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            
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
            
            let listResponse = try JSONDecoder().decode(BaseListResponse<Todo>.self, from: data)
            let todos = listResponse.data

            guard let todos = todos,
                  !todos.isEmpty else {
                throw ApiError.noContent
            }
            
            return listResponse
        } catch {
            if let apiError = error as? URLError {
                throw ApiError.badStatus(code: apiError.errorCode)
            }
            
            if let _ = error as? DecodingError {
                throw ApiError.decodingError
            }
            throw ApiError.unknown(error)
        }
    }
    
    
    /// 할 일 추가하기
    /// - Parameters:
    ///   - title: 할 일 타이틀
    ///   - isDone: 할 일 완료 여부
    ///   - completion: 응답 결과
    static func addATodoWithAsync(
        title: String,
        isDone: Bool = false) async throws ->
        BaseResponse<Todo>
    {
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos"
        
        guard let url = URL(string: urlString) else {
            throw ApiError.notAllowedUrl
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
        
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            
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
            
            return try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
        } catch {
            if let apiError = error as? URLError {
                throw ApiError.badStatus(code: apiError.errorCode)
            }
            
            if let _ = error as? DecodingError {
                throw ApiError.decodingError
            }
            
            throw ApiError.unknown(error)
        }
    }
    
    
    /// 할 일 추가하기(JSON)
    /// - Parameters:
    ///   - title: 할 일 타이틀
    ///   - isDone: 할 일 완료 여부
    ///   - completion: 응답 결과
    static func addATodoJSONWithAsync(
        title: String,
        isDone: Bool = false) async throws ->
        BaseResponse<Todo>
    {
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos-json"
        
        guard let url = URL(string: urlString) else {
            throw ApiError.notAllowedUrl
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
            throw ApiError.jsonEncodingError
        }
        
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            
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
            
            return try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
        } catch {
            if let apiError = error as? URLError {
                throw ApiError.badStatus(code: apiError.errorCode)
            }
            
            if let _ = error as? DecodingError {
                throw ApiError.decodingError
            }
            
            throw ApiError.unknown(error)
        }
    }
    
    
    /// 할 일 수정하기
    /// - Parameters:
    ///   - id: 수정할 아이템 아이디
    ///   - title: 할 일 타이틀
    ///   - isDone: 할 일 완료 여부
    ///   - completion: 응답 결과
    static func editTodoJsonWithAsync(
        id: Int,
        title: String,
        isDone: Bool = false) async throws ->
        BaseResponse<Todo>
    {
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos-json/\(id)"
        
        guard let url = URL(string: urlString) else {
            throw ApiError.notAllowedUrl
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
            throw ApiError.jsonEncodingError
        }
        
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            
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
            
            return try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
        } catch {
            if let apiError = error as? URLError {
                throw ApiError.badStatus(code: apiError.errorCode)
            }
            
            if let _ = error as? DecodingError {
                throw ApiError.decodingError
            }
            
            throw ApiError.unknown(error)
        }
    }
    
    
    /// 할 일 수정하기 - PUT urlEncoded
    /// - Parameters:
    ///   - id: 삭제할 아이템 아이디
    ///   - title: 할 일 타이틀
    ///   - isDone: 할 일 완료 여부
    ///   - completion: 응답 결과
    static func editATodoWithAsync(
        id: Int,
        title: String,
        isDone: Bool = false) async throws ->
        BaseResponse<Todo>
    {
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos/\(id)"
        
        guard let url = URL(string: urlString) else {
            throw ApiError.notAllowedUrl
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let requestParams : [String : String] = ["title":title, "is_done":"\(isDone)"]
        
        urlRequest.percentEncodeParameters(parameters: requestParams)
        
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            
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
            
            return try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
        } catch {
            if let apiError = error as? URLError {
                throw ApiError.badStatus(code: apiError.errorCode)
            }
            
            if let _ = error as? DecodingError {
                throw ApiError.decodingError
            }
            
            throw ApiError.unknown(error)
        }
    }
    
    
    /// 할 일 삭제하기 - DELETE
    /// - Parameters:
    ///   - id: 수정할 아이템 아이디
    static func deleteATodoWithAsync(id: Int) async throws->
        BaseResponse<Todo>
    {
        print(#fileID, #function, #line, "- deleteATodo 호출됨 / id : \(id)")
        
        // 1. urlRequest를 만든다.
        let urlString = baseURL + "/todos/\(id)"
        
        guard let url = URL(string: urlString) else {
            throw ApiError.notAllowedUrl
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")

        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            
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
            
            return try JSONDecoder().decode(BaseResponse<Todo>.self, from: data)
        } catch {
            if let apiError = error as? ApiError {
                throw apiError
            }
            
            if let apiError = error as? URLError {
                throw ApiError.badStatus(code: apiError.errorCode)
            }
            
            if let _ = error as? DecodingError {
                throw ApiError.decodingError
            }
            
            throw ApiError.unknown(error)
        }
    }
    
    
    /// 할 일 추가 후 모든 할 일 불러오기
    /// - Parameters:
    ///   - title: 추가할 제목
    ///   - isDone: 완료 여부
    ///   - completion: 응답 결과
    static func addTodoAndFetchTodosWithAsync(
        title: String,
        isDone: Bool = false) async throws -> [Todo]
    {
        // 이미 addATodoWithAsync에서 에러 처리가 되어있고, addTodoAndFetchTodosWithAsync에서도 에러가 나면 던지도록 되어있기 때문에
        // addATodoWithAsync를 감싸는 do/catch 구문을 작성할 필요가 없다.
        _ = try await addATodoWithAsync(title: title)
        let secondResult = try await fetchTodosWithAsync()
        
        guard let finalResult = secondResult.data else {
            throw ApiError.noContent
        }
        
        return finalResult
    }
    
    /// 할 일 추가 후 모든 할 일 불러오기 - No Error
    /// - Parameters:
    ///   - title: 추가할 제목
    ///   - isDone: 완료 여부
    ///   - completion: 응답 결과
    static func addTodoAndFetchTodosWithAsyncNoErr(
        title: String,
        isDone: Bool = false) async -> [Todo]
    {
        do {
            _ = try await addATodoWithAsync(title: title)
            let secondResult = try await fetchTodosWithAsync()
            
            guard let finalResult = secondResult.data else {
                return []
            }
            return finalResult
        } catch {
            if let _ = error as? ApiError {
                return []
            }
            return []
        }
    }
    
    
    /// 선택된 할 일들 삭제하기
    /// 동시에 처리
    /// - Parameters:
    ///   - seletedTodoIds: 선택된 할 일 아이디
    ///   - completion: 실제 삭제가 완료된 아이디들
    /// 위의 두 방법은 async await 을 이용해 첫 번째, 두 번째, 세 번째 결과를 기다렸다가 반환하는 방식이다.
    /// 이 경우 배열로 받은 선택된 아이디들을 처리하기가 곤란해진다.
    /// 그런 경우에는 두 번째 방법인 TaskGroup을 이용해서 처리해야 한다.
    static func deleteSeletedTodosWithAsyncNoError(selectedTodoIds: [Int]) async -> [Int] {
        async let firstResult = self.deleteATodoWithAsync(id: 1641)
        async let secondResult = self.deleteATodoWithAsync(id: 1641)
        async let thirdResult = self.deleteATodoWithAsync(id: 1641)
        
        do {
            let results : [Int?] = try await [firstResult.data?.id, secondResult.data?.id, thirdResult.data?.id]
            return results.compactMap { $0 }
        } catch {
            return []
        }
    }
    
    static func deleteSeletedTodosWithAsyncWithError(selectedTodoIds: [Int]) async throws-> [Int] {
        async let firstResult = self.deleteATodoWithAsync(id: 1641)
        async let secondResult = self.deleteATodoWithAsync(id: 1641)
        async let thirdResult = self.deleteATodoWithAsync(id: 1641)
        
        let results : [Int?] = try await [firstResult.data?.id, secondResult.data?.id, thirdResult.data?.id]
        return results.compactMap { $0 }
    }
    
    static func deleteSeletedTodosWithAsyncTaskGroupWithError(selectedTodoIds: [Int]) async throws-> [Int] {
        
        // Sendable.Protocol : TaskGorup을 하나하나 돌릴 때 반환하는 자료형
        // 아래 전체 작업을 기다리고, 에러를 던지기 때문에 try await을 해줘야 한다.
        try await withThrowingTaskGroup(of: Int?.self) { (group : inout ThrowingTaskGroup<Int?, Error>) in
            let todoIds = selectedTodoIds.map { $0 }
            
            // 각각 자식 async를 테스크를 그룹에 넣기
            for aTodoId in todoIds {
                group.addTask(operation: {
                    // 단일 API 전송
                    // 여기서 반환해야 하는 부분은 TaskGroup의 of , 즉 Sendable.Protocol 에서 지정한 자료형으로 반환해야 한다.
                    let childTaskResult = try await self.deleteATodoWithAsync(id: aTodoId)
                    return childTaskResult.data?.id
                })
            }
            
            var deleteTodoIds : [Int] = []
            
            for try await singleValue in group {
                if let value = singleValue {
                    deleteTodoIds.append(value)
                }
            }
            
            return deleteTodoIds
        }
    }
    
    static func deleteSeletedTodosWithAsyncTaskGroupNoError(selectedTodoIds: [Int]) async -> [Int] {
        
        // Sendable.Protocol : TaskGorup을 하나하나 돌릴 때 반환하는 자료형
        // 아래 전체 작업을 기다리고, 에러를 던지기 때문에 try await을 해줘야 한다.
        // 에러를 던지지 않는 TaskGroup
        await withTaskGroup(of: Int?.self) { (group : inout TaskGroup<Int?>) in
            let todoIds = selectedTodoIds.map { $0 }
            
            // 각각 자식 async를 테스크를 그룹에 넣기
            for aTodoId in todoIds {
                group.addTask(operation: {
                    do {
                        // 단일 API 전송
                        // 여기서 반환해야 하는 부분은 TaskGroup의 of , 즉 Sendable.Protocol 에서 지정한 자료형으로 반환해야 한다.
                        let childTaskResult = try await self.deleteATodoWithAsync(id: aTodoId)
                        return childTaskResult.data?.id
                    } catch {
                        return nil
                    }
                })
            }
            
            var deleteTodoIds : [Int] = []
            // 위에서 이미 do catch 구문으로 try를 처리했기 때문에 아래에서는 try를 뺄 수 있다.
            for await singleValue in group {
                if let value = singleValue {
                    deleteTodoIds.append(value)
                }
            }
            
            return deleteTodoIds
        }
    }
    
    
    /// 선택된 할 일들 가져오기
    /// 동시에 처리
    /// - Parameters:
    ///   - seletedTodoIds: 선택된 할 일 아이디
    ///   - completion: 응답결과
    static func fetchSelectedTodosAsyncNoError(selectedTodoIds: [Int]) async -> [Todo] {
        
        await withTaskGroup(of: Todo?.self) { (group : inout TaskGroup<Todo?>) in
            let todoIds = selectedTodoIds.map { $0 }
            
            // 각각 자식 async를 테스크를 그룹에 넣기
            for aTodoId in todoIds {
                group.addTask(operation: {
                    do {
                        // 단일 API 전송
                        // 여기서 반환해야 하는 부분은 TaskGroup의 of , 즉 Sendable.Protocol 에서 지정한 자료형으로 반환해야 한다.
                        let childTaskResult = try await self.fetchATodoWithAsync(id: aTodoId)
                        return childTaskResult.data
                    } catch {
                        return nil
                    }
                })
            }
            
            var fetchedTodos : [Todo] = []
            // 위에서 이미 do catch 구문으로 try를 처리했기 때문에 아래에서는 try를 뺄 수 있다.
            for await singleValue in group {
                if let value = singleValue {
                    fetchedTodos.append(value)
                }
            }
            
            return fetchedTodos
        }
    }

    static func fetchSelectedTodosAsyncWithError(selectedTodoIds: [Int]) async throws -> [Todo] {
        
        try await withThrowingTaskGroup(of: Todo?.self, body: { (group : inout ThrowingTaskGroup<Todo?, Error>) in
            for aTodoId in selectedTodoIds {
                group.addTask {
                    let childTaskResult = try await self.fetchATodoWithAsync(id: aTodoId)
                    return childTaskResult.data
                }
            }
            
            var fetchedTodos : [Todo] = []
            
            for try await singleValue in group {
                if let value = singleValue {
                    fetchedTodos.append(value)
                }
            }
            return fetchedTodos
        })
    }
}

//MARK: - Async -> Combine
extension TodosAPI {
    
    static func fetchTodosAsyncToPublisher(page: Int = 1) -> AnyPublisher<BaseListResponse<Todo>, Error> {
        
        return Future { (promise: @escaping (Result<BaseListResponse<Todo>, Error>) -> Void) in
            Task {
                do {
                    let asyncResult = try await fetchTodosWithAsync(page: page)
                    
                    promise(.success(asyncResult))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func genericAsyncToPublisher<T>(asyncWork: @escaping () async throws -> T) -> AnyPublisher<T, Error> {
        
        return Future { (promise: @escaping (Result<T, Error>) -> Void) in
            Task {
                do {
                    let asyncResult = try await asyncWork()
                    
                    promise(.success(asyncResult))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}


extension Publisher {
    
    /// asyncWork 중간에 다른 연산을 처리하기 위해 만든다.
    /// Output : Publisher 에서 나가는 데이터
    func mapAsyncr<T>(asyncWork: @escaping (Output) async throws -> T) -> Publishers.FlatMap<Future<T, Error>, Publishers.SetFailureType<Self, Error>> {
        return flatMap { output in
            return Future { (promise: @escaping (Result<T, Error>) -> Void) in
                Task {
                    do {
                        let asyncResult = try await asyncWork(output)
                        
                        promise(.success(asyncResult))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
    }
}
