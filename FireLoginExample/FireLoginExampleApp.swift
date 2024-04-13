//
//  FireLoginExampleApp.swift
//  FireLoginExample
//
//  Created by KISHORE KANKATA on 12/04/24.
//

import SwiftUI
import FireLogin
import Firebase

@main
struct FireLoginExampleApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: .init())
                .preferredColorScheme(.light)
        }
    }
}


enum RootView {
    case welcome
    case emailVerification
    case signupUserInformation
    case home
}
