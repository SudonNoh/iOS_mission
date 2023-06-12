//
//  TodosResponse.swift
//  WhatTodoApp
//
//  Created by Sudon Noh on 2023/05/19.
//


// MARK: - TodosResponse
struct TodoListResponse: Codable {
    let data: [Todo]?
    let meta: Meta?
    let message: String?
}

//MARK: - TodoResponse
struct TodoResponse: Codable {
    let data: Todo?
    let message: String?
}

// MARK: - Todo
struct Todo: Codable {
    let id: Int?
    var title: String?
    var isDone: Bool?
    let createdAt: String?
    var updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case isDone = "is_done"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Meta
struct Meta: Codable {
    let currentPage, from, lastPage, perPage: Int?
    let to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case from
        case lastPage = "last_page"
        case perPage = "per_page"
        case to, total
    }
    
    func hasNext() -> Bool {
        guard let current = currentPage,
              let last = lastPage else { return false }
        
        return current < last
    }
}

