//
//  CustomVM.swift
//  WhatTodoApp/Custom/CustomVM.swift
//
//  Created by Sudon Noh on 2023/05/30.
//

import Foundation

class CustomVM {
    //MARK: - Error Handler
    func errorHandler(_ err: Error) -> String {
        guard let apiError = err as? TodoAPI.APIError else {
            return ""
        }
        
        return apiError.info
    }
}
