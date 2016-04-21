//
//  V2Tests.swift
//  SimpleDomainModel
//
//  Created by Barron, Brandon on 4/20/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//


import XCTest
import SimpleDomainModel


class V2Tests: XCTestCase {
    
    // test description field for each class is as expected
    
    func testMoney() {
        let money = Money(amount: 42, currency: "CAN")
        XCTAssert(money.description == "CAN42")
    }
    
    func testJob() {
        let job = Job(title: "Software Engineer", type: Job.JobType.Hourly(11.0))
        XCTAssert(job.description == "Software Engineer")
    }
    
    func testPerson() {
        let person = Person(firstName: "Brandon", lastName: "Barron", age: 22)
        XCTAssert(person.description == "Name: Brandon Barron")
    }
    
    func testFamily() {
        let person1 = Person(firstName: "Brandon", lastName: "Barron", age: 22)
        let person2 = Person(firstName: "Imaginary", lastName: "Wife", age: 22)
        let family = Family(spouse1: person1, spouse2: person2)
        
        XCTAssert(family.description == "Family members: Brandon Barron, Imaginary Wife")
    }
    
    
    // test extension of Double
    
    func testDoubleExtension() {
        let usd = 42.0.USD
        XCTAssert(usd.amount == 42)
        XCTAssert(usd.currency == "USD")
        
        let eur = 1.0.EUR
        XCTAssert(eur.amount == 1)
        XCTAssert(eur.currency == "EUR")
        
        let gbp = 100.0.GBP
        XCTAssert(gbp.amount == 100)
        XCTAssert(gbp.currency == "GBP")
        
        let yen = 1500.0.YEN
        XCTAssert(yen.amount == 1500)
        XCTAssert(yen.currency == "YEN")
    }
}
