//
//  ForgotPasswordView.swift
//  FireLoginExample
//
//  Created by KISHORE KANKATA on 13/04/24.
//

import Foundation
import SwiftUI
import FireLogin

struct ForgotPasswordView: View {
    
    @StateObject private var viewModel: ForgotPasswordViewModel = .init()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("FORGOT PASSWORD")
                .font(.headline)
                .padding(.vertical, 18)
            
            VStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 30) {
                    InputTextField(title: "Email",
                                   placeHolder: "Enter your email id",
                                   inputText: $viewModel.emailText,
                                   errorText: .init())
                    .textContentType(.emailAddress)
                    .padding(.top, 20)
                }
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                Button(action: {
                    hideKeyboard()
                    viewModel.validateEmailAndSendLink()
                }, label: {
                    Text("SEND RESET LINK")
                        .textTitleStyle
                        .frame(width: 180, height: 40)
                })
                .buttonStyle(PrimaryButtonStyling())
                .frame(width: 180, height: 40, alignment: .center)
                .padding(.top, 50)
                if !viewModel.error.isEmpty {
                    ErrorLabel(text: viewModel.error)
                }
                Spacer()
            }
            .padding(20)
        }
        .overlay {
            if viewModel.loading {
                CustomProgressView(text: .init())
            }
        }
        .alert("Password reset link sent successfully. Please check your mail inbox",
               isPresented: $viewModel.sendLink) {
            Button(role: .cancel) {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("OK")
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}

final class ForgotPasswordViewModel: ObservableObject {
    
    @Published var sendLink: Bool = false
    var error: String = .init()
    @Published var loading: Bool = false
    @Published var emailText: String = .init()
    
    @MainActor
    func validateEmailAndSendLink() {
        error = .init()
        loading = true
        
        if !isValidEmail() {
            self.error = "Invalid email. Please try again"
            loading = false
            return
        }
        
        Task {
            do {
                try await FireAuthentication.shared.forgotPassword(withEmail: emailText)
                self.sendLink = true
            } catch {
                self.error = error.localizedDescription
                loading = false
            }
        }
    }
    
    private func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: emailText)
    }
}
