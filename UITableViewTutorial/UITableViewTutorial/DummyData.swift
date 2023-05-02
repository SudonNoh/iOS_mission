//
//  DummyData.swift
//  UITableViewTutorial
//
//  Created by Sudon Noh on 2023/05/01.
//

import Foundation
import Fakery


struct DummySection {
    let uuid: UUID
    
    let title: String
    let body: String
    
    let rows: [DummyData]
    
    init() {
        self.uuid = UUID()
        self.title = "섹션 타이틀 : \(uuid)"
        self.body = "섹션 본문: \(uuid)"
        self.rows = DummyData.getDummies(10)
    }
    
    static func getDummies(_ count: Int = 10) -> [DummySection] {
        (1...count).map { _ in DummySection()}
    }
}


struct DummyData {
    let uuid: UUID
    
    let title: String
    let body: String
    
    init() {
        self.uuid = UUID()
        
        let faker = Faker(locale: "ko")
        
        let firstName = faker.name.firstName()
        let lastName = faker.name.lastName()
        
        let body = faker.lorem.paragraphs(amount: 3)
        
        self.title = "제목 : \(lastName) \(firstName)"
        self.body = "본문: \(body)"
    }
    
    static func getDummies(_ count: Int = 100) -> [DummyData] {
        (1...count).map { _ in DummyData()}
    }
}


struct MyData {
    let uuid: UUID
    
    let title: String
    let body: String
    
    init() {
        self.uuid = UUID()
        
        let faker = Faker(locale: "ko")
        
        let firstName = faker.name.firstName()
        let lastName = faker.name.lastName()
        
        let body = faker.lorem.paragraphs(amount: 3)
        
        self.title = "제목 : \(lastName) \(firstName)"
        self.body = "본문: \(body)"
    }
    
    static func getDummies(_ count: Int = 100) -> [MyData] {
        (1...count).map { _ in MyData()}
    }
}
