//
//  Mock.swift
//  SwiftUISample
//
//  Created by Marco Wenzel on 08/03/2024.
//

import Foundation
import SwiftUI

extension View
{
    @MainActor
    func withPreviewEnvironments() -> some View {
        environmentObject(Navigator())
        .navigationDestination(for: Route.self) { route in
            destinationFor(route)
        }
    }
}
