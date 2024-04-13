//
//  SignupUserInfoView.swift
//  FireLoginExample
//
//  Created by KISHORE KANKATA on 13/04/24.
//

import SwiftUI
import FireLogin

struct SignupUserInfoView: View {
    
    @StateObject var viewModel: SignUpUserInfoViewModel = .init()
    @State var image: UIImage?
    @State var showImagePicker: Bool = false
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack {
                Text("TELL US ABOUT YOU")
                    .font(.headline)
                    .padding(.bottom, 15)
                ScrollView(showsIndicators: false) {
                    Button(action: {
                        showImagePicker = true
                    }, label: {
                        profileIconView
                            .padding(.top, 5)
                    })
                    VStack(alignment: .leading, spacing: 20) {
                        InputTextField(title: "Name*",
                                       placeHolder: "Enter your first & last name",
                                       inputText: $viewModel.nameText,
                                       errorText: viewModel.pageState == .nameError ? viewModel.pageState.rawValue : .init())
                            .textContentType(.name)
                            .keyboardType(.alphabet)
                            .disableAutocorrection(true)
                        consentView
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .center, spacing: 5) {
                        Button(action: {
                            viewModel.submitForm(withProfile: image)
                        }, label: {
                            Text("CONTINUE")
                                .textTitleStyle
                                .frame(width: 180, height: 40)
                        })
                            .buttonStyle(PrimaryButtonStyling())
                        
                        if viewModel.pageState == .updationFailure {
                            ErrorLabel(text: viewModel.pageState.rawValue)
                        }
                    }
                }
            }
            if viewModel.pageState == .updatingDetails {
                CustomProgressView(text: viewModel.pageState.rawValue)
            }
        }
        .fullScreenCover(isPresented: $showImagePicker, onDismiss: {}) {
            ImagePicker(image: $image)
                .ignoresSafeArea()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
    }
    
    @ViewBuilder
    var profileIconView: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(64)
            } else {
                ZStack {
                    Rectangle()
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color(.accent))
                        .clipShape(Circle())
                    Text("+\nAdd Image")
                        .font(.body)
                        .foregroundColor(Color(.secondary))
                }
            }
        }
        .overlay(RoundedRectangle(cornerRadius: 64)
                    .stroke(Color.white, lineWidth: 1)
        )
    }
    
    var consentView: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                Image( viewModel.approvedConsent ? "checkbox_selected" : "checkbox_unselected")
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)
                    .padding(10)
                    .onTapGesture {
                        viewModel.approvedConsent.toggle()
                    }
                Text("I am 18+ years old")
                    .textValueStyle
                Spacer()
            }
            if viewModel.pageState == .consentError {
                ErrorLabel(text: viewModel.pageState.rawValue)
            }
        }
        .padding()
    }
}

struct SignupUserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                SignupUserInfoView()
            }
        }
    }
}

final class SignUpUserInfoViewModel: ObservableObject {
    
    @Published var pageState: SignUpPageState = .allGood
    var nameText: String = .init()
    @Published var approvedConsent: Bool = false
    let notificationCenter = NotificationCenter.default
    
    func submitForm(withProfile image: UIImage?) {
        pageState = .updatingDetails
        
        UserDefaults.standard.setValue(false, forKey: "tutorialSeen")
        
        if validFields() {
            FireService.shared.saveUserFullName(name: nameText) { [weak self] error in
                guard let self = self else { return }
                if error != nil {
                    pageState = .updationFailure
                } else if image != nil {
                    FireStorage.shared.saveProfilePicture(image: image!) { [weak self] url in
                        guard let self = self else { return }
                        if let url = url {
                            FireService.shared.saveUserProfileURL(url: URL(string: url)) { error in
                                print(error ?? .init())
                                FireService.shared.saveUserInformation(userId: FireAuthentication.shared.currentUser!.uid, name: self.nameText, photoURL: url, email: FireAuthentication.shared.currentUser?.email ?? .init())
                                DispatchQueue.main.async {
                                    self.pageState = .allGood
                                    self.notificationCenter.post(name: .loginNotification, object: nil)
                                }
                            }
                        }
                    }
                } else {
                    FireService.shared.saveUserInformation(userId: FireAuthentication.shared.currentUser!.uid, name: self.nameText, photoURL: nil, email: FireAuthentication.shared.currentUser?.email ?? .init())
                    DispatchQueue.main.async {
                        self.pageState = .allGood
                        self.notificationCenter.post(name: .loginNotification, object: nil)
                    }
                }
            }
        }
    }
    
    
    func validFields() -> Bool {
        if nameText.isEmpty {
            pageState = .nameError
        } else if approvedConsent == false {
            pageState = .consentError
        } else {
            return true
        }
        return false
    }
}

public enum SignUpPageState: String {
    case updatingDetails = "Updating Details"
    case nameError = "Please enter your name"
    case consentError = "Please tell us that you are above 18 years old"
    case passwordError =  "Invalid Password"
    case updationFailure = "Updating data failed"
    case allGood = "All Good"
}


