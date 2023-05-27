//
//  TodoAPI.swift
//  WhatTodoApp
//
//  Created by Sudon Noh on 2023/05/18.
//

import Foundation
import RxSwift
import RxCocoa

enum TodoAPI {
    
    static let version = "v1"
    static let baseURL = "https://phplaravel-574671-2962113.cloudwaysapps.com/api/" + version
    
    static let session = URLSession.shared

    static func fetchTodos(_ page:Int = 1) -> Observable<TodoListResponse> {
        let urlString = baseURL + "/todos" + "?page=\(page)&order_by=desc&per_page=10"
        
        guard let url = URL(string: urlString) else { return Observable.error(APIError.notAllowedUrl) }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        return session
            .rx
            .response(request: urlRequest)
            .map { (response: HTTPURLResponse, data: Data) -> Data in
                return data
            }
            .decode(type: TodoListResponse.self, decoder: JSONDecoder())
    }
}
