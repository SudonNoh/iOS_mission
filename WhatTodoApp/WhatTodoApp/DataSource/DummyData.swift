//
//  DummyData.swift
//  WhatTodoApp
//
//  Created by Sudon Noh on 2023/05/18.
//

import Foundation
import Fakery


struct DummyData {
    let title : String
    let updateDate : String
    let createDate : String
    
    init() {
        let faker = Faker(locale: "ko")
        
        let count: Int = faker.number.randomInt(min: 1, max: 10)
        
        let fakeryTitle = faker.lorem.paragraph(sentencesAmount: count)
        let fakeryUpdatedDate = faker.date.birthday(1, 100) // Date 타입
        let fakeryCreatedDate = faker.date.birthday(1, 100)
        
        self.title = fakeryTitle
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH시 mm분"
        self.updateDate = dateFormatter.string(from: fakeryUpdatedDate)
        self.createDate = dateFormatter.string(from: fakeryCreatedDate)
    }
    
    static func getDummies(_ count: Int = 100) -> [DummyData] {
        (1...count).map { _ in DummyData()}
    }
}
