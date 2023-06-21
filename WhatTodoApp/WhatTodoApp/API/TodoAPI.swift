//
//  TodoAPI.swift
//  WhatTodoApp
//
//  Created by Sudon Noh on 2023/05/18.
//

import Foundation
import RxSwift
import RxCocoa

public enum OrderBy {
    case desc
    case asc
}

enum TodoAPI {
    
    static let version = Env.version
    static let baseURL = Env.baseURL + version
    
    static let session = URLSession.shared
    
    /// Fetch Todo Items
    /// - Parameters:
    ///   - page: 검색된 결과 페이지
    ///   - filterBy: 정렬 방법 2. 생성된 날짜, 수정된 날짜
    ///   - orderBy: 정렬 방법 1. 오름차순, 내림차순
    ///   - isDone: 게시물의 완료 여부로 필터
    ///   - perPage: 페이지당 게시물 수
    /// - Returns: Observable<TodoListResponse> 형태로 반환
    static func fetchTodos(_ page:Int = 1,
                           _ filterBy: String = "created_at",
                           _ orderBy: OrderBy = .desc,
                           _ isDone: Bool? = nil,
                           _ perPage: Int = 10) -> Observable<TodoListResponse> {
        
        var isDoneUrl = ""
        
        if let boolValue = isDone { isDoneUrl = "&is_done=\(boolValue)" }
        
        let urlString = baseURL + "/todos" + "?page=\(page)&filter=\(filterBy)&order_by=\(orderBy)\(isDoneUrl)&per_page=\(perPage)"
        
        guard let url = URL(string: urlString) else { return Observable.error(APIError.notAllowedUrl) }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        return session
            .rx
            .response(request: urlRequest)
            .map { (urlResponse: HTTPURLResponse, data: Data) -> Data in
                
                switch urlResponse.statusCode {
                case 400: throw APIError.badStatus(code: 400)
                default: break
                }
                
                if  !(200...299).contains(urlResponse.statusCode) {
                    throw APIError.badStatus(code: urlResponse.statusCode)
                }
                
                return data
            }
            .decode(type: TodoListResponse.self, decoder: JSONDecoder())
            .map { response in
                guard let todos = response.data,
                      !todos.isEmpty else {
                    throw APIError.noContent
                }
                return response
            }
            .catch { err in
                
                if let error = err as? APIError {
                    throw error
                }
                
                if let _ = err as? DecodingError {
                    throw APIError.decodingError
                }
                
                throw APIError.unknown(err)
            }
    }
    
    /// Delete a Todo Item
    /// - Parameter id: 게시물의 고유 번호
    /// - Returns: Observable<TodoResponse> 형태로 반환
    static func deleteATodo(id: Int) -> Observable<TodoResponse> {
        
        let urlString = baseURL + "/todos/\(id)"
        
        guard let url = URL(string: urlString) else { return Observable.error(APIError.notAllowedUrl) }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        return session
            .rx
            .response(request: urlRequest)
            .map { (urlResponse: HTTPURLResponse, data: Data) -> Data in
                
                switch urlResponse.statusCode {
                case 401: throw APIError.unauthorized
                case 204: throw APIError.noContent
                default: break
                }
                
                return data
            }
            .decode(type: TodoResponse.self, decoder: JSONDecoder())
            .catch { err in
                
                if let error = err as? APIError { throw error }
                if let _ = err as? DecodingError { throw APIError.decodingError }
                
                throw APIError.unknown(err)
            }
    }
    
    /// Update a Todo Item
    /// - Parameters:
    ///   - id: 게시물의 고유 번호
    ///   - title: 게시물 내용
    ///   - isDone: 완료 여부
    /// - Returns: 업데이트가 완료된 게시물을 Observable<TodoResponse> 형태로 반환
    static func updateATodo(id: Int,
                            title: String,
                            isDone: Bool) -> Observable<TodoResponse>{
        
        let urlString = baseURL + "/todos/\(id)"
        
        guard let url = URL(string: urlString) else { return Observable.error(APIError.notAllowedUrl) }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let requestParams : [String : String] = ["title":title, "is_done":"\(isDone)"]
        
        urlRequest.percentEncodeParameters(parameters: requestParams)
        
        return session
            .rx
            .response(request: urlRequest)
            .map { (urlResponse: HTTPURLResponse, data: Data) -> Data in
                
                switch urlResponse.statusCode {
                case 401: throw APIError.unauthorized
                case 404: throw APIError.noContent
                default: break
                }
                
                return data
            }
            .decode(type: TodoResponse.self, decoder: JSONDecoder())
            .catch { err in
                
                if let error = err as? APIError { throw error }
                if let _ = err as? DecodingError { throw APIError.decodingError }
                
                throw APIError.unknown(err)
            }
    }
    
    /// Add a Todo Item
    /// - Parameters:
    ///   - title: 게시물 내용
    ///   - isDone: 완료 여부
    /// - Returns: 추가된 게시물을 Observable<TodoResponse> 형태로 반환
    static func addATodo(title: String, isDone: Bool) -> Observable<TodoResponse> {
        let urlString = baseURL + "/todos"
        
        guard let url = URL(string: urlString) else { return Observable.error(APIError.notAllowedUrl)}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestParams : [String:Any] = ["title":title, "is_done":"\(isDone)"]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestParams, options: [.prettyPrinted])
            urlRequest.httpBody = jsonData
        } catch {
            return Observable.error(APIError.jsonEncodingError)
        }
        
        return session
            .rx
            .response(request: urlRequest)
            .map { (urlResponse: HTTPURLResponse, data: Data) -> Data in
                
                switch urlResponse.statusCode {
                case 401: throw APIError.unauthorized
                case 404: throw APIError.noContent
                default: break
                }
                
                return data
            }
            .decode(type: TodoResponse.self, decoder: JSONDecoder())
            .catch { err in
                
                if let error = err as? APIError { throw error }
                if let _ = err as? DecodingError { throw APIError.decodingError }
                
                throw APIError.unknown(err)
            }
    }
    
    
    /// Search API Function
    /// - Parameters:
    ///   - searchTerm: 검색어
    ///   - page: 검색된 결과 페이지
    ///   - orderBy: 정렬 방법 1. 오름차순, 내림차순
    ///   - filterBy: 정렬 방법 2. 생성된 날짜, 수정된 날짜
    ///   - perPage: 페이지당 게시물 수
    ///   - isDone: 게시물의 완료 여부로 필터
    /// - Returns: Observable<TodoListResponse> 형태로 반환
    static func searchTodos(searchTerm: String,
                            page: Int = 1,
                            orderBy: OrderBy = .desc,
                            filterBy: String = "created_at",
                            perPage: Int = 10,
                            isDone: Bool? = nil) -> Observable<TodoListResponse> {
        
        var urlComponents = URLComponents(string: baseURL + "/todos/search")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "query", value: searchTerm),
            URLQueryItem(name: "filter", value: filterBy),
            URLQueryItem(name: "order_by", value: "\(orderBy)"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        
        if let boolValue = isDone {
            urlComponents?.queryItems?.append(URLQueryItem(name: "is_done", value: "\(boolValue)"))
        }
        
        guard let url = urlComponents?.url else {
            return Observable.error(APIError.notAllowedUrl)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")

        return session
            .rx
            .response(request: urlRequest)
            .map { (urlResponse: HTTPURLResponse, data: Data) -> Data in
                
                switch urlResponse.statusCode {
                case 401: throw APIError.unauthorized
                case 404: throw APIError.noContent
                case 204: throw APIError.noContent
                default: break
                }
                
                return data
            }
            .decode(type: TodoListResponse.self, decoder: JSONDecoder())
            .catch { err in
                
                if let error = err as? APIError { throw error }
                if let _ = err as? DecodingError { throw APIError.decodingError }
                
                throw APIError.unknown(err)
            }
    }
}
