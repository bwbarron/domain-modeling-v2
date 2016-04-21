//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

public func testMe() -> String {
    return "I have been tested"
}

public class TestMe {
    public func Please() -> String {
        return "I have been tested"
    }
}


protocol Mathematics {
    func add(to: Money) -> Money
    func subtract(from: Money) -> Money
}


extension Double {
    var USD: Money { return Money(amount: Int(self), currency: "USD") }
    var EUR: Money { return Money(amount: Int(self), currency: "EUR") }
    var GBP: Money { return Money(amount: Int(self), currency: "GBP") }
    var YEN: Money { return Money(amount: Int(self), currency: "YEN") }
}


////////////////////////////////////
// Money
//
public struct Money : CustomStringConvertible, Mathematics {
    public var amount : Int
    public var currency : String
    public var description : String {
        return "\(currency)\(amount)"
    }
    
    public func convert(to: String) -> Money {
        // maps currency types relative to USD
        let currMap = ["USD" : 1.0, "GBP" : 0.5, "EUR" : 1.5, "CAN" : 1.25]
        
        if let conv = currMap[to] {
            return Money(amount: Int((Double(self.amount) / currMap[self.currency]!) * conv), currency: to)
        } else {
            print("cannot convert to currency type", to)
            exit(1)
        }
    }
    
    public func add(to: Money) -> Money {
        return Money(amount: self.convert(to.currency).amount + to.amount, currency: to.currency)
    }
    public func subtract(from: Money) -> Money {
        return Money(amount: from.amount - self.convert(from.currency).amount, currency: from.currency)
    }
}


////////////////////////////////////
// Job
//
public class Job : CustomStringConvertible {
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    var title : String
    var salary : JobType
    
    public var description: String {
        return self.title
    }
    
    public init(title : String, type : JobType) {
        self.title = title
        self.salary = type
    }
    
    public func calculateIncome(hours: Int) -> Int {
        switch self.salary {
        case .Hourly(let rate):
            return Int(Double(hours) * rate)
        case .Salary(let salary):
            return salary
        }
    }
    
    public func raise(amt : Double) {
        switch self.salary {
        case .Hourly(let rate):
            self.salary = JobType.Hourly(rate + amt)
        case .Salary(let salary):
            self.salary = JobType.Salary(salary + Int(amt))
        }
    }
}


////////////////////////////////////
// Person
//
public class Person : CustomStringConvertible {
    public var firstName : String = ""
    public var lastName : String = ""
    public var age : Int = 0
    private var _job : Job?
    private var _spouse : Person?
    
    public var job : Job? {
        get { return self._job }
        set(value) {
            if self.age >= 16 {
                self._job = value!
            }
        }
    }
    
    public var spouse : Person? {
        get { return self._spouse }
        set(value) {
            if self.age >= 18 {
                self._spouse = value!
            }
        }
    }
    
    public var description: String {
        return "Name: \(firstName) \(lastName)"
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    public func toString() -> String {
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age)" +
            " job:\(self._job) spouse:\(self._spouse)]"
    }
}


////////////////////////////////////
// Family
//
public class Family : CustomStringConvertible {
    private var members : [Person] = []
    
    public var description: String {
        var desc = "Family members:"
        members.forEach({ (member : Person) -> () in
            desc += " \(member.firstName) \(member.lastName),"
        })
        desc.removeAtIndex(desc.endIndex.predecessor()) // drop trailing comma
        print(desc)
        return desc
    }
    
    public init(spouse1: Person, spouse2: Person) {
        if spouse1.spouse == nil && spouse2.spouse == nil && (spouse1.age > 21 || spouse2.age > 21) {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            self.members.append(spouse1)
            self.members.append(spouse2)
        } else {
            print("spouses cannot already be married and there must be at least one over the age of 21")
            exit(1)
        }
    }
    
    public func haveChild(child: Person) -> Bool {
        self.members.append(child)
        return true
    }
    
    public func householdIncome() -> Int {
        var totalIncome = 0
        self.members.forEach({ (member : Person) -> () in
            if let job = member.job {
                var hours : Int
                switch job.salary {
                case .Hourly(_):
                    hours = 40 * 50
                case .Salary(_):
                    hours = 0
                }
                totalIncome += job.calculateIncome(hours)
            }
        })
        return totalIncome
    }
}
