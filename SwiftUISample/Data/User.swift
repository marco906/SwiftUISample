//
//  User.swift
//  SwiftUISample
//
//  Created by Marco Wenzel on 08/03/2024.
//

import Foundation

struct User: Identifiable, Equatable, Hashable, Codable {
    var name: String
    var email: String
    var birthday: Date
    
    var id: String { email }
    var birthdayDisplay: String { birthday.formatted(date: .abbreviated, time: .omitted) }
}
