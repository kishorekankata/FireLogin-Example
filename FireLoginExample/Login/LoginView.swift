//
//  LoginView.swift
//  FireLoginExample
//
//  Created by KISHORE KANKATA on 13/04/24.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel: LoginViewModel
    @State var forgotPassword: Bool = false
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack {
                    VStack(alignment: .center, spacing: 10) {
                        Image("app_logo")
                            .renderingMode(.original)
                            .scaleEffect(1.5)
                            .frame(width: 226, height: 43, alignment: .center)
                            .padding(.vertical, 30)
                        if viewModel.pageType == .signUp {
                            VStack(alignment: .center, spacing: 10) {
                                Text("Sign up using your Email")
                                    .textValueStyle
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.horizontal)
                        }
                       
                        VStack(alignment: .leading, spacing: 20) {
                            InputTextField(title: "Email",
                                           placeHolder: "enter your email address",
                                           inputText: $viewModel.emailText,
                                           errorText: viewModel.loginPageState == .emailError || viewModel.loginPageState == .emailDomainError ? viewModel.loginPageState.rawValue : .init())
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .padding(.top, 20)
                            InputTextField(title: "Password",
                                           placeHolder: viewModel.pageType.passwordPlaceHolder,
                                           inputText: $viewModel.password,
                                           errorText: viewModel.loginPageState == .passwordError ? viewModel.loginPageState.rawValue : .init(), masked: true)
                                .textContentType(.password)
                            
                            if viewModel.pageType == .signIn {
                                Button(action: {
                                    forgotPassword = true
                                }, label: {
                                    NavigationLink(isActive: $forgotPassword) {
                                        ForgotPasswordView()
                                    } label: {
                                        Text("Forgot password?")
                                            .font(.body)
                                            .foregroundColor(Color(.accent))
                                    }
                                })
                                .padding(.horizontal, 20)
                            }
                        }
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        
                        VStack(spacing: .zero) {
                            VStack(alignment: .center, spacing: 5) {
                                Button(action: clickNext, label: {
                                    Text(viewModel.pageType.nextButtonTitle)
                                        .font(.body)
                                        .frame(width: 180, height: 40)
                                })
                                    .buttonStyle(PrimaryButtonStyling())
                                    .padding(.top)
                                if viewModel.loginPageState == .signInFailed {
                                    Text(viewModel.errorString)
                                        .foregroundColor(Color(.red))
                                        .font(.caption)
                                }
                            }
                            consentView
                        }
                        Spacer()
                    }
                }
                if viewModel.loginPageState == .signingInProgress || viewModel.loginPageState == .validatingEmail {
                    CustomProgressView(text: viewModel.loginPageState.rawValue)
                }
            }
        }
    }
    
    
    var consentView: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                Image(viewModel.approvedConsent ? "checkbox_selected" : "checkbox_unselected")
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(Color.accent)
                    .frame(width: 20, height: 20, alignment: .center)
                    .padding(10)
                    .onTapGesture {
                        viewModel.approvedConsent.toggle()
                    }
                NavigationLink {
                    Text("Terms of Service")
                } label: {
                    Text("Terms & Conditions")
                        .textTitleStyle
                        .foregroundColor(Color(.accent))
                }
                Spacer()
            }
            if viewModel.loginPageState == .consentError {
                ErrorLabel(text: viewModel.loginPageState.rawValue)
            }
        }
        .padding()
    }
    
    func clickNext() {
        viewModel.nextClicked()
        self.hideKeyboard()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView(viewModel: .init(pageType: .signUp))
        }
    }
}
