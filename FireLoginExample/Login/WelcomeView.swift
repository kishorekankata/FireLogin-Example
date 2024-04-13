//
//  WelcomeView.swift
//  FireLoginExample
//
//  Created by KISHORE KANKATA on 13/04/24.
//

import SwiftUI

struct WelcomeView: View {
    
    @StateObject var viewModel: WelcomeViewModel = .init()
    
    var body: some View {
        ZStack {
            VStack {
                Image("app_text_logo")
                    .renderingMode(.original)
                    .scaleEffect(1.5)
                    .frame(width: 226, height: 43, alignment: .center)
                    .padding(.top, 200)
                Spacer(minLength: 200)
                signUpButton
                loginButton
                    .padding(.top, 35)
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
    
    var signUpButton: some View {
        NavigationLink(isActive: $viewModel.activateSignUp) {
            LoginView(viewModel: .init(pageType: .signUp))
        } label: {
            VStack(alignment: .center, spacing: 5) {
                Button(action: { viewModel.activateSignUp = true }, label: {
                    Text("SIGN UP")
                        .font(.body)
                        .frame(width: 180, height: 40)
                })
                .buttonStyle(SignUpButtonStyling())
            }
        }
    }
    
    var loginButton: some View {
        NavigationLink(isActive: $viewModel.activateSignIn) {
            LoginView(viewModel: .init(pageType: .signIn))
        } label: {
            VStack(alignment: .center, spacing: 5) {
                Button(action: { viewModel.activateSignIn = true }, label: {
                    Text("LOG IN")
                        .font(.body)
                        .frame(width: 180, height: 40)
                })
                .buttonStyle(PrimaryButtonStyling())
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}


final class WelcomeViewModel: ObservableObject {
    
    @Published var activateSignUp: Bool = false
    @Published var activateSignIn: Bool = false
    
}


enum LoginType {
    case signUp
    case signIn
}

extension LoginType {
    var title: String {
        self == .signIn ? "LOG IN" : "SIGN UP"
    }
    
    var passwordPlaceHolder: String {
        self == .signIn ? "enter your password" : "enter new password"
    }
    
    var nextButtonTitle: String {
        self == .signIn ? "LOG IN" : "NEXT"
    }
}
