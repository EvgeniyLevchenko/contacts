//
//  contact.swift
//  contacts
//
//  Created by QwertY on 10.11.2021.
//

import UIKit

public struct Person: Equatable {
    var name: String
    var phoneNumber: String
    var email: String
    var notes: String
    var avatar = UIImage(systemName: "person.circle")
    
    public static func == (leftValue: Person, rightValue: Person) -> Bool {
        return
            leftValue.name == rightValue.name &&
            leftValue.phoneNumber == rightValue.phoneNumber &&
            leftValue.email == rightValue.email &&
            leftValue.notes == rightValue.notes &&
            leftValue.avatar == rightValue.avatar
    }
}
//FIX-ME: - extension??
// yes
extension Person {
    init() {
        self.name = ""
        self.phoneNumber = ""
        self.email = ""
        self.notes = ""
    }
}
//FIX-ME: - global var
public var friends: [Person] = [
    Person(name: "Evgeniy Levchenko", phoneNumber: "333-242-2555", email: "q@gmail.com", notes: "JABSFJKSbfisdiubfusdbfbsdfsdbufibdsufbdsufbusboawjfyeeccfvgtyhuijokfsdbjnfwifjenjbvnweubfdskfmwfnsdkjfniowbvjajduwhd"),
    Person(name: "Matthew McConaughey", phoneNumber: "333-444-5555", email: "qw@gmail.com", notes: ""),
    Person(name: "John Appleseed", phoneNumber: "333-444-5555", email: "qwe@gmail.com", notes: ""),
    Person(name: "Jason Berry", phoneNumber: "333-444-5555", email: "qwer@gmail.com", notes: ""),
    Person(name: "Laura Harper", phoneNumber: "333-444-5555", email: "qwert@gmail.com", notes: ""),
    Person(name: "Indiana Jones", phoneNumber: "333-444-5555", email: "qwerty@gmail.com", notes: ""),
    Person(name: "Guy Ritchie", phoneNumber: "333-444-5555", email: "qwerty1@gmail.com", notes: "")
]

public var recent: [Person] = []
 

