//
//  Navigator.swift
//  SwiftUISample
//
//  Created by Marco Wenzel on 08/03/2024.
//

import Foundation

import SwiftUI

@MainActor
class Navigator: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ destination: Route) {
        path.append(destination)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRooot() {
        path.removeLast(path.count)
    }
}
