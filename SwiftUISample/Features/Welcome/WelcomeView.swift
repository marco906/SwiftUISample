//
//  WelcomeView.swift
//  SwiftUISample
//
//  Created by Marco Wenzel on 09/03/2024.
//

import SwiftUI

struct WelcomeViewArguments: Hashable {
    var user: User? = nil
}

struct WelcomeView: View {
    @StateObject var model = WelcomeViewModel()
    var user: User?
    
    init(_ args: WelcomeViewArguments) {
        self.user = args.user
    }
    
    var body: some View {
        content
            .task {
                start()
            }
    }
    
    @ViewBuilder
    var content: some View {
        switch model.state {
        case .loading:
            ProgressView()
        case let .normal(user):
            welcome(user: user)
        case let .error(msg):
            Text(msg)
        }
    }
    
    func welcome(user: User) -> some View {
        Text("Hallo, \(user.name)!") // TODO: localize
    }
    
    func start() {
        model.setup(user: user)
        model.start()
    }
}

#Preview {
    WelcomeView(
        WelcomeViewArguments(user: User(name: "Max Mustermann", email: "max.mustermann@example.com", birthday: Date.now))
    )
}
