//
//  ContentView.swift
//  SwiftUISample
//
//  Created by Marco Wenzel on 08/03/2024.
//

import SwiftUI

struct MainView: View {
    @StateObject var navigator = Navigator()
    
    var body: some View {
        NavigationStack(path: $navigator.path) {
            rootView
                .navigationDestination(for: Route.self) { route in
                    destinationWitEnvironments(route)
                }
        }
    }
    
    var rootView: some View {
        RegisterView(RegisterViewArguments())
    }
    
    func destinationWitEnvironments(_ route: Route) -> some View {
        destinationFor(route)
            .environmentObject(navigator)
    }
}

#Preview {
    MainView()
}
