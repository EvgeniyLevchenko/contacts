//
//  contact.swift
//  contacts
//
//  Created by QwertY on 10.11.2021.
//

import UIKit

struct Person {
    var name: String
    
    var phoneNumber: String
    var email: String
    var notes: String

    var avatar = UIImage(systemName: "person.circle")
    
}
//FIX-ME: - extension??
extension Person {
    init() {
        self.name = ""
        self.phoneNumber = ""
        self.email = ""
        self.notes = ""
    }
}
//FIX-ME: - global var
var friends: [Person] = [
    Person(name: "Evgeniy Levchenko", phoneNumber: "333-242-2555", email: "q@gmail.com", notes: "JABSFJKSbfisdiubfusdbfbsdfsdbufibdsufbdsufbusboawjfyeeccfvgtyhuijokfsdbjnfwifjenjbvnweubfdskfmwfnsdkjfniowbvjajduwhd"),
    Person(name: "Matthew McConaughey", phoneNumber: "333-444-5555", email: "qw@gmail.com", notes: ""),
    Person(name: "John Appleseed", phoneNumber: "333-444-5555", email: "qwe@gmail.com", notes: ""),
    Person(name: "Jason Berry", phoneNumber: "333-444-5555", email: "qwer@gmail.com", notes: ""),
    Person(name: "Laura Harper", phoneNumber: "333-444-5555", email: "qwert@gmail.com", notes: ""),
    Person(name: "Indiana Jones", phoneNumber: "333-444-5555", email: "qwerty@gmail.com", notes: ""),
    Person(name: "Guy Ritchie", phoneNumber: "333-444-5555", email: "qwerty1@gmail.com", notes: "")
]

var recent: [Person] = []
 

