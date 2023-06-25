//
//  APIError.swift
//  WhatTodoApp
//
//  Created by Sudon Noh on 2023/05/27.
//

import Foundation
import UIKit

extension TodoAPI {
    enum APIError: Error {
        case noContent
        case unauthorized
        case decodingError
        case jsonEncodingError
        case notAllowedUrl
        case badStatus(code: Int)
        case errResponseFromServer(_ errResponse: ErrorResponse?)
        case unknown(_ err: Error?)
        
        var info : String {
            switch self {
            case .noContent :                               return "데이터가 없습니다."
            case .decodingError :                           return "디코딩 에러입니다."
            case .jsonEncodingError :                       return "유효한 JSON 형식이 아닙니다."
            case .unauthorized :                            return "인증되지 않은 사용자입니다."
            case .notAllowedUrl :                           return "올바른 url 형식이 아닙니다."
            case .badStatus(let code) :                     return "상태코드 \(code )에러입니다."
            case .errResponseFromServer(let errResponse):   return errResponse?.message ?? ""
            case .unknown:                                  return "알 수 없는 에러입니다."
            }
        }
        
        var code : Int {
            switch self {
            case .noContent : return 204
            default: return 999
            }
        }
    }
}
