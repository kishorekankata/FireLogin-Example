//
//  ContentView.swift
//  FireLoginExample
//
//  Created by KISHORE KANKATA on 12/04/24.
//

import UIKit
import SwiftUI
import FireLogin

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        NavigationView {
            switch viewModel.rootView {
                case .welcome:
                    WelcomeView()
                case .emailVerification:
                    PhoneVerificationView()
                case .signupUserInformation:
                    SignupUserInfoView()
                        .navigationBarHidden(true)
                case .home:
                    Text("Welcome...")
                        .navigationBarHidden(true)
            }
        }
    }
}

class ContentViewModel: ObservableObject {
    
    @Published var rootView: RootView = .welcome {
        didSet {
            self.handleNotifications()
        }
    }
    let notificationCenter: NotificationCenter = .default
    
    init() {
        if UserDefaults.standard.value(forKey: Constants.userEmailID) == nil {
            rootView = .welcome
        } else {
            let userState = FireAuthentication.shared.userStatus()
            switch userState {
            case .welcome:
                rootView = .welcome
            case .emailNotVerified:
                rootView = .emailVerification
            case .signupNotCompleted:
                rootView = .signupUserInformation
            case .loggedIn:
                rootView = .home
            }
        }
    }
}

//MARK:- Notifications
extension ContentViewModel {
    
    func handleNotifications() {
        switch rootView {
        case .welcome:
            observeLoginNotification(userState: .welcome)
            observeSignUpNotification()
            observeLogoutNotification()
        case .signupUserInformation:
            observeLoginNotification(userState: .signupNotCompleted)
            observeLogoutNotification()
        case .home:
            observeLogoutNotification()
        default:
            observeLoginNotification(userState: .signupNotCompleted)
            observeLogoutNotification()
        }
    }
    
    func observeLoginNotification(userState: UserState) {
        notificationCenter.removeObserver(self, name: .loginNotification, object: nil)
        
        let notifications = notificationCenter.notifications(named: .loginNotification, object: nil)
        if userState != .loggedIn {
            Task {
                for await notification in notifications {
                    print(notification.name)
                    DispatchQueue.main.async {
                        self.rootView = .home
                        self.notificationCenter.removeObserver(self, name: .loginNotification, object: nil)
                    }
                    break
                }
            }
        }
    }
    
    func observeSignUpNotification() {
        self.notificationCenter.removeObserver(self, name: .signUpNotification, object: nil)
        
        let notifications = notificationCenter.notifications(named: .signUpNotification, object: nil)
        Task {
            for await notification in notifications {
                print(notification.name)
                DispatchQueue.main.async {
                    self.rootView = .emailVerification
                    self.notificationCenter.removeObserver(self, name: .signUpNotification, object: nil)
                }
                break
            }
        }
    }
    
    func observeLogoutNotification() {
        self.notificationCenter.removeObserver(self, name: .logoutNotification, object: nil)
        
        let notifications = notificationCenter.notifications(named: .logoutNotification, object: nil)
        Task {
            
            for await notification in notifications {
                print(notification.name)
                DispatchQueue.main.async {
                    self.rootView = .welcome
                    self.notificationCenter.removeObserver(self, name: .logoutNotification, object: nil)
                }
                break
            }
        }
    }
}
