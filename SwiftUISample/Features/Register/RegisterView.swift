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
            .task {
                start()
            }
    }
    
    var form: some View {
        Form {
            header
            formField(.name)
            formField(.email)
            formField(.birthday)
            registerButton
        }
    }
    
    @ViewBuilder
    var header: some View {
        Section {

        } header: {
            switch model.state {
            case .loading, .normal:
                Text(Strings.registerHeaderDefaultMsg)
            case let .error(msg):
                Text(msg)
                    .foregroundStyle(.red)
            }
        }
        .textCase(nil)
        .font(.subheadline)
        .listRowBackground(Color.clear)
        .listSectionSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var registerButton: some View {
        Button(Strings.registerButtonTitle, action: clickedRegister)
            .disabled(!model.canSubmit)
    }
    
    @ViewBuilder
    func formField(_ field: RegisterFormField) -> some View {
        Section {
            switch field {
            case .name:
                TextField(field.description, text: $model.name)
                    .onChange(of: model.name) { newValue in
                        model.validateField(.name)
                    }
            case .email:
                TextField(field.description, text: $model.email)
                    .keyboardType(.emailAddress)
                    .onChange(of: model.email) { newValue in
                        model.validateField(.email)
                    }
            case .birthday:
                DatePicker(field.description, selection: $model.birthday, displayedComponents: .date)
                    .onChange(of: model.birthday) { newValue in
                        model.validateField(.birthday)
                    }
            }
        } header: {
            Text(field.title)
        } footer: {
            if let errorMsg = model.errorForField(field)?.msg {
                Text(errorMsg)
                    .foregroundStyle(.red)
            }
        }
    }
    
    func start() {
        model.setup(onAction: handleAction)
    }
    
    func clickedRegister() {
        model.register()
    }
    
    func handleAction(_ action: RegisterModelAction) {
        switch action {
        case .success: openWelcome()
        }
    }
    
    func openWelcome() {
        let args = WelcomeViewArguments()
        navigator.push(.welcome(args))
    }
}

#Preview {
    NavigationStack {
        RegisterView(RegisterViewArguments())
            .withPreviewEnvironments()
    }
}
