//
//  customFunction.swift
//  WhatTodoApp
//
//  Created by Sudon Noh on 2023/05/30.
//

import Foundation

/// Change Date Format String To String with Custom String
/// - Parameters:
///   - frontString: It will be front of return value
///   - date: date String
/// - Returns: frontString + date : "frontString + yyyy-MM-dd HH시 mm분"
public func dateFormatter(frontString: String, date: String) -> String {
    
    let dateFormat1st = "yyyy-MM-dd'T'HH:mm:ss.ssssssZ"
    let dateFormat2nd = "yyyy-MM-dd HH시 mm분"
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat1st
    let dateFromString = dateFormatter.date(from: date)
    
    dateFormatter.dateFormat = dateFormat2nd
    guard let confirmDate = dateFromString else { return "" }
    let stringDate = dateFormatter.string(from: confirmDate)
    
    return frontString + " " + stringDate
}
