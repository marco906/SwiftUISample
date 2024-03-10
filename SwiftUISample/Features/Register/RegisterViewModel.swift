//
//  RegisterViewModel.swift
//  SwiftUISample
//
//  Created by Marco Wenzel on 08/03/2024.
//

import Foundation
import SwiftUI

class RegisterViewModel: ObservableObject {
    @Published var state = RegisterModelState.normal
    @Published var name = ""
    @Published var email = ""
    @Published var birthday = Date.now
    
    @Published var validationErrors = [RegisterFormField:ValidationError]()
    
    var store: Store = DefaultsStore.shared
    
    var onAction: ((RegisterModelAction) -> Void)?
    
    var canRegister: Bool { state == RegisterModelState.normal }
    
    func setup(onAction: @escaping (RegisterModelAction) -> Void) {
        self.onAction = onAction
    }
    
    func errorForField(_ field: RegisterFormField) -> ValidationError? {
        validationErrors[field]
    }
    
    private func addErrorFor(_ field: RegisterFormField, error: ValidationError) {
        validationErrors[field] = error
    }
    
    private func clearErrorFor(_ field: RegisterFormField) {
        validationErrors.removeValue(forKey: field)
    }
    
    func validateName(_ name: String) throws {
        guard !name.isEmpty else {
            addErrorFor(.name, error: .invalidName)
            throw ValidationError.invalidName
        }
        clearErrorFor(.name)
    }
    
    func validateEmail(_ email: String) throws {
        let pattern = /([a-zA-Z0-9._-]+)(@{1})([a-zA-Z0-9.-]+)(.{1})([a-zA-Z]{2,})/
        guard email.wholeMatch(of: pattern) != nil else {
            addErrorFor(.email, error: .invalidEmail)
            throw ValidationError.invalidEmail
        }
        clearErrorFor(.email)
    }
    
    func validateBirthday(_ date: Date) throws {
        let calendar = Calendar.current
        let minDateComponents = DateComponents(year: 1900, month: 1, day: 1)
        let maxDateComponents = DateComponents(year: 2022, month: 12, day: 31)
        
        guard let minDate = calendar.date(from: minDateComponents),
              let maxDate = calendar.date(from: maxDateComponents),
              date >= minDate && date <= maxDate else {
            addErrorFor(.birthday, error: .invalidBirthday)
            throw ValidationError.invalidBirthday
        }
        
        clearErrorFor(.birthday)
    }
    
    private func validateFields() throws {
        try validateName(name)
        try validateEmail(email)
        try validateBirthday(birthday)
    }
    
    private func saveUser() throws {
        let user = User(name: name, email: email, birthday: birthday)
        try store.setJSONObject(user, forKey: Keys.Storage.currentUser)
    }
    
    func register() {
        state = .loading
        
        do {
            try validateFields()
            try saveUser()
        } catch {
            var errorMsg: LocalizedStringKey = ""
            
            switch error {
            case is ValidationError:
                errorMsg = Strings.registerErrorValidationMsg
            case is StorageError:
                errorMsg = Strings.registerErrorSaveMsg
            default:
                errorMsg = Strings.registerErrorGeneralMsg
            }
            
            state = .error(msg: errorMsg)
            return
        }
        
        state = .normal
        onAction?(.success)
    }
}

enum RegisterModelState: Equatable {
    case loading
    case normal
    case error(msg: LocalizedStringKey)
}

enum RegisterFormField: Int, Hashable {
    case name
    case email
    case birthday
    
    var title: LocalizedStringKey {
        switch self {
        case .name:
            Strings.registerFieldNameTitle
        case .email:
            Strings.registerFieldEmailTitle
        case .birthday:
            Strings.registerFieldBirthdayTitle
        }
    }
    
    var description: LocalizedStringKey {
        switch self {
        case .name:
            Strings.registerFieldNameDescription
        case .email:
            Strings.registerFieldEmailDescription
        case .birthday:
            Strings.registerFieldBirthdayDescription
        }
    }
}

enum ValidationError: LocalizedError {
    case invalidName
    case invalidEmail
    case invalidBirthday
    
    var msg: LocalizedStringKey {
        switch self {
        case .invalidName:
            Strings.registerValidationErrorNameMsg
        case .invalidEmail:
            Strings.registerValidationErrorEmailMsg
        case .invalidBirthday:
            Strings.registerValidationErrorBirthdayMsg
        }
    }
    
    var errorDescription: String {
        return NSLocalizedString("\(msg)", comment: "")
    }
}

enum RegisterModelAction {
    case success
}
