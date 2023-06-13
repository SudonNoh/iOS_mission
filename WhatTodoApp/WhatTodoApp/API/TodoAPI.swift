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
    
    static let version = "v2"
    static let baseURL = "https://phplaravel-574671-2962113.cloudwaysapps.com/api/" + version
    
    static let session = URLSession.shared

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
}
