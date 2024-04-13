//
//  PhoneVerificationView.swift
//  FireLoginExample
//
//  Created by KISHORE KANKATA on 13/04/24.
//

import SwiftUI
import FireLogin

struct PhoneVerificationView: View {
    
    @StateObject private var viewModel: PhoneVerificationViewModel = .init()
    
    var body: some View {
        VStack {
            Text("VERIFY PHONE")
                .textTitleStyle
                .padding(.vertical, 25)
            VStack {
                NavigationLink(destination: SignupUserInfoView(), isActive: $viewModel.phoneVerified) { EmptyView() }
                VStack(alignment: .center, spacing: 15) {
                    VStack(alignment: .leading, spacing: 20) {
                        InputTextField(title: "Phone Number",
                                       placeHolder: "enter your phone number",
                                       inputText: $viewModel.phoneNumber,
                                       errorText: viewModel.pageState == .phoneNumberError ? viewModel.pageState.rawValue : .init(), countryCode: viewModel.countryCode)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                        
                        if viewModel.didSentOTP {
                            InputTextField(title: "Verification Code",
                                           placeHolder: "Enter OTP sent to your phone",
                                           inputText: $viewModel.OTP,
                                           errorText: viewModel.pageState == .oTPError ? viewModel.pageState.rawValue : .init())
                            .textContentType(.oneTimeCode)
                            .keyboardType(.numberPad)
                        }
                    }
                    if viewModel.showError() {
                        ErrorLabel(text: viewModel.pageState.rawValue)
                    }
                    Button(action: {
                        self.hideKeyboard()
                        viewModel.didSentOTP ? viewModel.verifyOTP() : viewModel.sendOTP()
                    } , label: {
                        Text( viewModel.didSentOTP ? "Verify" : "Send Code")
                            .font(.title)
                            .frame(width: 180, height: 40)
                    })
                    .buttonStyle(PrimaryButtonStyling())
                    .padding(.bottom, 20)
                    
                    if viewModel.didSentOTP {
                        Button(action: viewModel.sendOTP, label: {
                            Text("Re-send Code")
                                .frame(width: 180, height: 40)
                        })
                        .buttonStyle(PrimaryButtonStyling())
                        .padding(.bottom, 25)
                    }
                }
            }
            Spacer()
        }
        .overlay {
            if viewModel.showProgress() {
                CustomProgressView(text: viewModel.pageState.rawValue)
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Image("back_icon")
                    .renderingMode(.template)
                    .foregroundColor(.accent)
                    .onTapGesture {
                        FireAuthentication.shared.currentUser?.delete(completion: { error in
                            if let error = error {
                                print("\(error) while deleting user")
                            } else {
                                print("User deleted successfully")
                            }
                        })
                        _ = FireAuthentication.shared.logout()
                    }
            }
        })
    }
    
    private var goBackButton: some View {
        Button(action: {
            FireAuthentication.shared.currentUser?.delete(completion: { error in
                if let error = error {
                    print("\(error) while deleting user")
                } else {
                    print("User deleted successfully")
                }
            })
            _ = FireAuthentication.shared.logout()
        }, label: {
            Text("Go back")
                .frame(width: 180, height: 40)
        })
        .buttonStyle(PrimaryButtonStyling())
    }
}

struct PhoneVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneVerificationView()
    }
}


final class PhoneVerificationViewModel: ObservableObject {
    
    @Published var phoneVerified: Bool = false
    var countryCode: String = "+91"
    @Published var phoneNumber: String = .init()
    @Published var didSentOTP: Bool = false
    @Published var OTP: String = .init()
    @Published var pageState: PhoneNumberPageState = .allGood
    
    func sendOTP() {
        pageState = .sendingCode
        let number = countryCode + phoneNumber
        if number.isEmpty || number == "+91"{
            pageState = .phoneNumberError
        } else {
            FireAuthentication.shared.startAuth(phoneNumber: number) { success in
                self.didSentOTP = success
                self.pageState = success ? .allGood : .oTPSendingFailure
            }
        }
    }
    
    func verifyOTP() {
        pageState = .validatingCode
        if OTP.isEmpty {
            pageState = .oTPError
        } else {
            FireAuthentication.shared.verifyCode(smsCode: OTP) { success in
                self.phoneVerified = success
                self.pageState = success ? .allGood : .signInFailed
            }
        }
    }
    
    func showProgress() -> Bool {
        let states: [PhoneNumberPageState] = [.sendingCode, .validatingCode]
        return states.contains(pageState)
    }
    
    func showError() -> Bool {
        let states: [PhoneNumberPageState] = [.oTPSendingFailure, .signInFailed]
        return states.contains(pageState)
    }
}


public enum PhoneNumberPageState: String {
    case sendingCode = "Sending Code"
    case validatingCode = "Validating Code"
    case allGood = "All Good"
    case phoneNumberError = "Invalid Phone Number"
    case oTPSendingFailure = "Couldn't verify your Phone Number, Please try again later"
    case oTPError = "Invalid OTP"
    case signInFailed = "This phone number is already associated with a different user account."
}
