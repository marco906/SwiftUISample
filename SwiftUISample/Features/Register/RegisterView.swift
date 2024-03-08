//
//  RegisterView.swift
//  SwiftUISample
//
//  Created by Marco Wenzel on 08/03/2024.
//

import SwiftUI

struct RegisterViewArguments: Hashable {
    
}

struct RegisterView: View {
    @StateObject var model = RegisterViewModel()
    @EnvironmentObject var navigator: Navigator
    
    init(_ args: RegisterViewArguments) {
        
    }
    
    var body: some View {
        form
            .navigationTitle("Register")
    }
    
    var form: some View {
        Form {
            nameSection
            emailSection
            dateSection
            registerButton
        }
    }
    
    var nameSection: some View {
        Section("Name") {
            TextField("Enter your name", text: $model.name)
        }
    }
    
    var emailSection: some View {
        Section("Email") {
            TextField("Email address", text: $model.email)
                .keyboardType(.emailAddress)
        }
    }
    
    var dateSection: some View {
        Section("Date of birth") {
            DatePicker("Birthday", selection: $model.birthday, displayedComponents: .date)
                .datePickerStyle(.automatic)
        }
    }
    
    var registerButton: some View {
        Button("Register", action: clickedRegister)
    }
    
    func clickedRegister() {
        navigator.push(.register(RegisterViewArguments()))
    }
}

#Preview {
    NavigationStack {
        RegisterView(RegisterViewArguments())
            .withPreviewEnvironments()
    }
}
