//
//  URLRequest+Ext.swift
//  TodoAppTutorial
//
//  Created by Sudon Noh on 2023/05/03.
//

import Foundation

extension URLRequest {
    private func percenEscapeString(_ string: String) -> String {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-._* ")
        
        return string
            .addingPercentEncoding(withAllowedCharacters: characterSet)!
            .replacingOccurrences(of: " ", with: "+")
            .replacingOccurrences(of: " ", with: "+", options: [], range: nil)
    }
    
    mutating func percentEncodeParameters(parameters: [String : String]) {
        let parameterArray = parameters.map { (arg) -> String in
            let (key, value) = arg
            return "\(key)=\(self.percenEscapeString(value))"
        }
        
        httpBody = parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
    }
}
