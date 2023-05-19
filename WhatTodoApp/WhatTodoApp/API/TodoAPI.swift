//
//  TodoAPI.swift
//  WhatTodoApp
//
//  Created by Sudon Noh on 2023/05/18.
//

import Foundation
import RxAlamofire
import RxSwift

class TodoAPI {
    
    static let version = "v1"
    static let baseURL = "https://phplaravel-574671-2962113.cloudwaysapps.com/api/" + version
    
    var disposeBag = DisposeBag()
    
    static func fetchTodos(_ page:Int = 1) {
        let urlString = baseURL + "/todos" + "?page=\(page)"
//        let session = URLSession.shared
//        let data = session.rx.json(.get, urlString).observeOn(MainScheduler.instance).subscribe { print($0) }
        
    }
}
