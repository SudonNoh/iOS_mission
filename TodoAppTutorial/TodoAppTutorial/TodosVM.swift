//
//  TodosVM.swift
//  TodoAppTutorial
//
//  Created by Sudon Noh on 2023/05/02.
//

import Foundation
import Combine


class TodosVM: ObservableObject {
    
    init() {
        print(#fileID, #function, #line, "- ")
        TodosAPI.fetchTodos { result in
            switch result {
            case .success(let todosResponse):
                print("TodosVM - todosResponse: \(todosResponse)")
            case .failure(let failure):
                print("TodosVM - failure: \(failure)")
            }

        }
    }
}
