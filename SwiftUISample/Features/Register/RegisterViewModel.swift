//
//  RegisterViewModel.swift
//  SwiftUISample
//
//  Created by Marco Wenzel on 08/03/2024.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var birthday = Date.now
    
    func validateName(_ name: String) throws {
        guard !name.isEmpty else {
            throw ValidationError.invalidName
        }
    }
    
    func validateEmail(_ email: String) throws {
        let pattern = /([a-zA-Z0-9._-]+)(@{1})([a-zA-Z0-9.-]+)(.{1})([a-zA-Z]{2,})/
        guard email.wholeMatch(of: pattern) != nil else {
            throw ValidationError.invalidEmail
        }
    }
    
    func validateBirthday(_ date: Date) throws {
        let calendar = Calendar.current
        let minDateComponents = DateComponents(year: 1900, month: 1, day: 1)
        let maxDateComponents = DateComponents(year: 2022, month: 12, day: 31)
        
        guard let minDate = calendar.date(from: minDateComponents), let maxDate = calendar.date(from: maxDateComponents) else {
            throw ValidationError.invalidBirthday
        }
        
        guard date >= minDate && date <= maxDate else {
            throw ValidationError.invalidBirthday
        }
    }
    
    private func validate() throws {
        try validateName(name)
        try validateEmail(email)
        try validateBirthday(birthday)
    }
    
    private func save() {
        // TODO: save user object
    }
    
    func register() {
        do {
            try validate()
        } catch {
            // TODO: handle errors
        }
        save()
        // TODO: push to welcome screen
    }
}

enum ValidationError: LocalizedError {
    case invalidName
    case invalidEmail
    case invalidBirthday
    
    // TODO: Add error descriptions
}
