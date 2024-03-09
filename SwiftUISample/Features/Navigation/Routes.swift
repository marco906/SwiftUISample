//
//  Routes.swift
//  SwiftUISample
//
//  Created by Marco Wenzel on 08/03/2024.
//

import Foundation
import SwiftUI

enum Route: Identifiable, Hashable {
    case register(_ args: RegisterViewArguments)
    case welcome(_ args: WelcomeViewArguments)
    
    var id: Int { hashValue }
}

@MainActor
extension View {
    @ViewBuilder
    func destinationFor(_ route: Route) -> some View
    {
        switch route
        {
        case let .register(args):
            RegisterView(args)
        case let .welcome(args):
            WelcomeView(args)
        }
    }
}
