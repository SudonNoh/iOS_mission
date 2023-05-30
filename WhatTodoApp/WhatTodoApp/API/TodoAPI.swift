//
//  TodoAPI.swift
//  WhatTodoApp
//
//  Created by Sudon Noh on 2023/05/18.
//

import Foundation
import RxSwift
import RxCocoa

public enum orderBy: Int {
    case desc = 0
    case asc = 1
}

enum TodoAPI {
    
    static let version = "v1"
    static let baseURL = "https://phplaravel-574671-2962113.cloudwaysapps.com/api/" + version
    
    static let session = URLSession.shared

    static func fetchTodos(_ page:Int = 1,
                           _ orderBy: orderBy = .desc,
                           _ perPage: Int = 10) -> Observable<TodoListResponse> {
        
        let urlString = baseURL + "/todos" + "?page=\(page)&order_by=\(orderBy)&per_page=\(perPage)"
        
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
}
