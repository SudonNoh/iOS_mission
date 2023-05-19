//
//  TodoVM.swift
//  WhatTodoApp
//
//  Created by Sudon Noh on 2023/05/19.
//

import Foundation


class TodoVM {
    init() {
        print("TodoVM init")
        TodoAPI.fetchTodos()
    }
}
