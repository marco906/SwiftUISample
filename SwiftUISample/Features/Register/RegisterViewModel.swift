//
//  RegisterViewModel.swift
//  SwiftUISample
//
//  Created by Marco Wenzel on 08/03/2024.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var state = RegisterModelState.normal
    @Published var name = ""
    @Published var email = ""
    @Published var birthday = Date.now
    @Published var validationErrors = Set<ValidationError>()
    
    var onAction: ((RegisterModelAction) -> Void)?
    
    var canRegister: Bool { state == .normal }
    
    func setup(onAction: @escaping (RegisterModelAction) -> Void) {
        self.onAction = onAction
    }
    
    func addErrorFor(_ error: ValidationError) {
        validationErrors.insert(error)
    }
    
    func clearErrorFor(_ error: ValidationError) {
        validationErrors.remove(error)
    }
    
    func validateName(_ name: String) throws {
        guard !name.isEmpty else {
            addErrorFor(.invalidName)
            throw ValidationError.invalidName
        }
        clearErrorFor(.invalidName)
    }
    
    func validateEmail(_ email: String) throws {
        let pattern = /([a-zA-Z0-9._-]+)(@{1})([a-zA-Z0-9.-]+)(.{1})([a-zA-Z]{2,})/
        guard email.wholeMatch(of: pattern) != nil else {
            addErrorFor(.invalidEmail)
            throw ValidationError.invalidEmail
        }
        clearErrorFor(.invalidEmail)
    }
    
    func validateBirthday(_ date: Date) throws {
        let calendar = Calendar.current
        let minDateComponents = DateComponents(year: 1900, month: 1, day: 1)
        let maxDateComponents = DateComponents(year: 2022, month: 12, day: 31)
        
        guard let minDate = calendar.date(from: minDateComponents),
              let maxDate = calendar.date(from: maxDateComponents),
              date >= minDate && date <= maxDate else {
            addErrorFor(.invalidEmail)
            throw ValidationError.invalidBirthday
        }
        
        clearErrorFor(.invalidBirthday)
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
        state = .loading
        
        do {
            try validate()
        } catch {
            if let _ = error as? ValidationError {
                state = .error
                return
            }
        }
        
        save()
        
        state = .normal
        onAction?(.success)
    }
}

enum RegisterModelState {
    case loading
    case normal
    case error
}

enum ValidationError: LocalizedError {
    case invalidName
    case invalidEmail
    case invalidBirthday
    
    // TODO: Add error descriptions
}

enum RegisterModelAction {
    case success
}
