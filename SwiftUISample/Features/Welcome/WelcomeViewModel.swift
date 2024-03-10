//
//  WelcomeViewModel.swift
//  SwiftUISample
//
//  Created by Marco Wenzel on 10/03/2024.
//

import Foundation
import SwiftUI

class WelcomeViewModel: ObservableObject {
    @Published var state = WelcomeModelState.loading
    @Published var user: User?
    
    var store: Store = DefaultsStore.shared
    
    func setup(user: User?) {
        self.user = user
    }
    
    func start() {
        if state != .loading {
            state = .loading
        }
        
        do {
            try fetchCurrentUserIfNedded()
        } catch {
            handleError(error)
        }
    }
    
    func fetchCurrentUserIfNedded() throws {
        if let usr = user {
            state = .normal(user: usr)
        } else {
            let fetchedUser = try fetchCurrentUser()
            self.user = fetchedUser
            state = .normal(user: fetchedUser)
        }
    }
    
    func fetchCurrentUser() throws -> User {
        let key = Keys.Storage.currentUser
        return try store.getJSONObject(User.self, forKey: key)
    }
    
    func handleError(_ error: Error) {
        // TODO: Handle Error
        //state = .error()
    }
}

enum WelcomeModelState: Equatable {
    case loading
    case normal(user: User)
    case error(msg: LocalizedStringKey)
}
