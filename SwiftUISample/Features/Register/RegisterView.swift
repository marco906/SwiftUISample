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
    @FocusState private var focusedField: RegisterFormField?
    
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
    
    var header: some View {
        Group {
            switch model.state {
            case .loading, .normal:
                dotBanner(msg: Strings.registerHeaderDefaultMsg)
            case let .error(msg):
                dotBanner(msg: msg, color: .red)
            }
        }
        .font(.subheadline)
        .listRowBackground(Color.clear)
        .listSectionSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
    }
    
    func dotBanner(msg: LocalizedStringKey, color: Color = Color.accentColor) -> some View {
        HStack(alignment: .top) {
            Image(systemName: "circle.fill")
                .font(.system(size: 8))
                .padding(.top, 4)
                .padding(.leading, 2)
                .foregroundStyle(color)
            Text(msg)
                .foregroundStyle(Color.secondary)
        }
    }
    
    @ViewBuilder
    func formField(_ field: RegisterFormField) -> some View {
        Section {
            switch field {
            case .name:
                TextField(field.description, text: $model.name)
                    .autocorrectionDisabled()
                    .submitLabel(.continue)
                    .focused($focusedField, equals: field)
                    .onChange(of: model.name) { newValue in
                        model.validateField(.name)
                    }
            case .email:
                TextField(field.description, text: $model.email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.continue)
                    .focused($focusedField, equals: field)
                    .onChange(of: model.email) { newValue in
                        model.validateField(.email)
                    }
            case .birthday:
                DatePicker(selection: $model.birthday, displayedComponents: .date) {
                    Text(field.description)
                        .foregroundStyle(.tertiary)
                }
                .listRowBackground(Color.clear)
                .accessibilityLabel(field.title)
                .focused($focusedField, equals: field)
                .accessibilityValue(model.birthday.formatted(date: .abbreviated, time: .omitted))
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
        .accessibilityLabel(field.title)
        .onSubmit(focusNext)
    }
    
    var registerButton: some View {
        Button(action: clickedRegister) {
            Text(Strings.registerButtonTitle)
                .font(.headline)
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity)
        }
        .padding(.top)
        .listRowBackground(Color.clear)
        .buttonStyle(.borderedProminent)
        .disabled(!model.canSubmit)
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
    
    func focusNext() {
        switch focusedField {
        case .name:
            focusedField = .email
        case .email:
            focusedField = .birthday
        case .birthday:
            focusedField = nil
        case nil:
            focusedField = .name
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView(RegisterViewArguments())
            .withPreviewEnvironments()
    }
}
