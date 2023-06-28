// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let giphyResponse = try? JSONDecoder().decode(GiphyResponse.self, from: jsonData)

import Foundation

// MARK: - GiphyResponse
struct GiphyResponse: Codable {
    let data: [Giphy]?
    let pagination: Pagination?
    let meta: Meta?
}

// MARK: - Datum
struct Giphy: Codable {
    let id: String?
    let images: Images?


    enum CodingKeys: String, CodingKey {
        case id
        case images
    }
    
    func getUrl() -> URL? {
        let urlString = self.images?.downsized?.url ?? ""
        return URL(string: urlString)
    }
}

// MARK: - Images
struct Images: Codable {
    let downsized: Downsized?

    enum CodingKeys: String, CodingKey {
        case downsized
    }
}

// MARK: - Downsized
struct Downsized: Codable {
    let height, width, size: String?
    let url: String?
}

// MARK: - Meta
struct Meta: Codable {
    let status: Int?
    let msg, responseID: String?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case responseID = "response_id"
    }
}

// MARK: - Pagination
struct Pagination: Codable {
    let totalCount, count, offset: Int?

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count, offset
    }
}
