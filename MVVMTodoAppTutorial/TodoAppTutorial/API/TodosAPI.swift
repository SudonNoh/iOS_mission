//
//  TodosAPI.swift
//  TodoAppTutorial
//
//  Created by Sudon Noh on 2023/05/02.
//

import Foundation
import MultipartForm

enum TodosAPI {
    static let version = "v1"
    
    #if DEBUG // 디버그용, 테스터 서버로 사용
    static let baseURL = "https://phplaravel-574671-2962113.cloudwaysapps.com/api/" + version
    #else // 릴리즈
    static let baseURL = "https://phplaravel-574671-2962113.cloudwaysapps.com/api/" + version
    #endif
    
    enum ApiError : Error {
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
            case .noContent :           return "데이터가 없습니다."
            case .decodingError :       return "디코딩 에러입니다."
            case .jsonEncodingError :   return "유효한 JSON 형식이 아닙니다."
            case .unauthorized :        return "인증되지 않은 사용자입니다.."
            case .notAllowedUrl :       return "올바른 url 형식이 아닙니다."
            case .badStatus(let code) : return "상태코드 \(code )에러입니다."
            case .errResponseFromServer(let errResponse): return errResponse?.message ?? ""
            case .unknown(let err) :    return "알 수 없는 에러입니다. \(err) 입니다."
            }
        }
    }
}
