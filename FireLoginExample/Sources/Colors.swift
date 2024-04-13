//
//  Colors.swift
//  FireLoginExample
//
//  Created by KISHORE KANKATA on 13/04/24.
//

import Foundation
import SwiftUI

extension Color {
    static var accent: Color = Color.init(.accent)
    static var secondary: Color = Color.init(.secondary)
    static var primaryText: Color = Color.init(.primaryText)
    static var textfieldBorder: Color = Color.init(uiColor: .textfieldBorder)
    static var errorColor: Color = Color.init(uiColor: .errorColor)
    static var tabBarItemColor: Color = Color.init(uiColor: .tabBarItemColor)
    static var loginGradientOne: Color = Color.init(uiColor: .loginGradientOne)
    static var loginGradientTwo: Color = Color.init(uiColor: .loginGradientTwo)
}

extension UIColor {
    static var accent: UIColor = .init(light: .init(hexString: "#e31e31"),
                                        dark: .init(hexString: "#e31e31"))
    static var secondary: UIColor = .init(light: .white,
                                          dark: .init(hexString: "#636363"))
    static var primaryText: UIColor = .init(light: UIColor(red: 0.387, green: 0.387, blue: 0.387, alpha: 1),
                                            dark: .white)
    static var errorColor: UIColor = .init(light: .init(hexString: "#D73A57"),
                                           dark: .init(hexString: "#D73A57"))
    static var tabBarItemColor: UIColor = .init(light: .init(hexString: "#DFDFDF"),
                                                dark: .init(hexString: "#DFDFDF"))
    static var textfieldBorder: UIColor = .init(light: UIColor(red: 0.387, green: 0.387, blue: 0.387, alpha: 1),
                                                dark: UIColor(red: 0.625, green: 0.625, blue: 0.625, alpha: 1))
    static var loginGradientOne: UIColor = .init(light: .init(hexString: "#D73A57"),
                                                 dark: .init(hexString: "#D73A57"))
    static var loginGradientTwo: UIColor = .init(light: .init(hexString: "#D52E86"),
                                                 dark: .init(hexString: "#D52E86"))
}

extension UIColor {
    convenience init(light: UIColor, dark: UIColor) {
        self.init { scheme in
            switch scheme.userInterfaceStyle {
            case .dark:
                return dark
            case .light:
                return light
            case .unspecified:
                fallthrough
            @unknown default:
                return dark
            }
        }
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

