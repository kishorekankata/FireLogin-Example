//
//  LoginViewModel.swift
//  FireLoginExample
//
//  Created by KISHORE KANKATA on 13/04/24.
//

import Foundation
import FireLogin

@MainActor
final class LoginViewModel: ObservableObject {
    
    @Published var emailText: String = .init()
    @Published var password: String = .init()
    @Published var userState: UserState = .welcome
    @Published var loginPageState: LoginPageState = .allGood
    var enableNavigation: Bool = false
    var errorString: String = .init()
    var pageType: LoginType
    @Published var approvedConsent: Bool = false
    
    init(pageType: LoginType) {
        self.pageType = pageType
        if self.pageType == .signIn {
            approvedConsent = true
        }
    }
    
    func nextClicked() {
        if validFields() {
            loginPageState = .validatingEmail
            if pageType == .signIn {
                FireAuthentication.shared.signInUser(with: emailText, password: password) { [weak self] result in
                    self?.handleFireLoginResponse(result)
                }
            } else {
                FireAuthentication.shared.createUser(with: emailText, password: password) { [weak self] result in
                    self?.handleFireLoginResponse(result)
                }
            }
        }
    }
    
    private func handleFireLoginResponse(_ response: FireLoginResponse?) {
        guard let error = response?.error else {
            errorString = .init()
            loginPageState = .allGood
            let notificationCenter: NotificationCenter = .default
            if pageType == .signIn {
                notificationCenter.post(name: .loginNotification, object: nil)
            } else {
                notificationCenter.post(name: .signUpNotification, object: nil)
            }
            return
        }
        errorString = error
        loginPageState = .signInFailed
    }
    
    private func validFields() -> Bool {
        if !isValidEmail() {
            loginPageState = .emailError
            return false
        } else if !isValidPassword() {
            loginPageState = .passwordError
            return false
        } else if approvedConsent == false {
            loginPageState = .consentError
            return false
        }
        return true
    }
    
    private func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: emailText)
    }
    
    private func isValidPassword() -> Bool {
        !password.trimmingCharacters(in: CharacterSet.whitespaces).trimmingCharacters(in: .newlines).isEmpty
    }
    
}

public enum LoginPageState: String {
    
    case signingInProgress = "Signing in"
    case validatingEmail = "Validating Credentials"
    case allGood = "All Good"
    case emailError = "Invalid Email"
    case emailDomainError = "Enter a '.edu' email only!"
    case passwordError =  "Invalid Password"
    case signInFailed = "Sign in Failure"
    case consentError = "You must agree to Terms & Conditions"
}
