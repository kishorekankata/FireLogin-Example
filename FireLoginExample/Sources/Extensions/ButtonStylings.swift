//
//  ButtonStylings.swift
//  FireLoginExample
//
//  Created by KISHORE KANKATA on 13/04/24.
//

import SwiftUI

struct PrimaryButtonStyling: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.largeTitle)
            .textCase(.uppercase)
            .background(Color(.accent))
            .foregroundColor(.white)
            .cornerRadius(2)
            .shadow(color: .primaryText.opacity(0.3), radius: 8, x: 1, y: 1)
    }
}

struct SignUpButtonStyling: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.largeTitle)
            .textCase(.uppercase)
            .background(Color(.white))
            .foregroundColor(.accent)
            .cornerRadius(2)
            .shadow(color: .primaryText.opacity(0.3), radius: 8, x: 1, y: 1)
    }
}


struct TextFieldHighlightStyle: TextFieldStyle {
    
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .font(.body)
    }
    
}
