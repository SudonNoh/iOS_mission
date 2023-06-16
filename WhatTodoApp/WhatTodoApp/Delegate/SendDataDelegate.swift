//
//  SendDataDelegate.swift
//  WhatTodoApp
//
//  Created by Sudon Noh on 2023/06/16.
//

import Foundation

// SendDataDelegate
protocol SendDataDelegate: AnyObject {
    func refreshList(_ bool: Bool)
}
