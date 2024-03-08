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
    
    func register() {
        // TODO: validate
        // TODO: push to welcome screen
    }
}
