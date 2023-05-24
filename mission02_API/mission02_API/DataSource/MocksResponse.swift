//
//  MocksResponse.swift
//  mission02_API
//
//  Created by Sudon Noh on 2023/05/20.
//

import Foundation

// MARK: - MocksResponse
struct MocksResponse: Codable {
    let data: [Mock]?
    let meta: Meta?
    let message: String?
}

// MARK: - MockResponse
struct MockResponse: Codable {
    let data: Mock?
    let message: String?
}

// MARK: - Mock
struct Mock: Codable {
    let id: Int?
    let email: String?
    let avatar: String?
    let title, content: String?
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
              let last = lastPage else {
            return false
        }
        return current < last
    }
}
