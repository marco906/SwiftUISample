//
//  RegisterView.swift
//  SwiftUISample
//
//  Created by Marco Wenzel on 08/03/2024.
//

import SwiftUI

struct RegisterViewArguments {
    
}

struct RegisterView: View {
    @StateObject var model = RegisterViewModel()
    
    init(_ args: RegisterViewArguments) {
        
    }
    
    var body: some View {
        Text("Hello")
    }
}

#Preview {
    RegisterView(RegisterViewArguments())
}
