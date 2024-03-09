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
            .navigationTitle(Strings.registerNavigationTitle)
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
        Section(Strings.registerFieldNameTitle) {
            TextField(Strings.registerFieldNameDescription, text: $model.name)
        }
    }
    
    var emailSection: some View {
        Section(Strings.registerFieldEmailTitle) {
            TextField(Strings.registerFieldEmailDescription, text: $model.email)
                .keyboardType(.emailAddress)
        }
    }
    
    var dateSection: some View {
        Section(Strings.registerFieldBirthdayTitle) {
            DatePicker(Strings.registerFieldBirthdayDescription, selection: $model.birthday, displayedComponents: .date)
                .datePickerStyle(.automatic)
        }
    }
    
    var registerButton: some View {
        Button(Strings.registerButtonTitle, action: clickedRegister)
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
