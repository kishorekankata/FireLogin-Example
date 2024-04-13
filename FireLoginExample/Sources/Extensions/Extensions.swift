//
//  Extensions.swift
//  FireLoginExample
//
//  Created by KISHORE KANKATA on 13/04/24.
//

import SwiftUI

extension Notification.Name {
    static let loginNotification = Notification.Name("loginNotification")
    static let signUpNotification = Notification.Name("signUpNotification")
    static let logoutNotification = Notification.Name("logoutNotification")
}

extension Text {
    var textValueStyle: some View {
        self
            .font(.body)
            .foregroundColor(Color(.primaryText))
    }
    
    var textTitleStyle: some View {
        self
            .font(.body)
            .foregroundColor(Color(.primaryText))
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
