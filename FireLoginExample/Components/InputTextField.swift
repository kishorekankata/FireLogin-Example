//
//  InputTextField.swift

import Foundation
import SwiftUI

struct InputTextField: View {
    
    var title: String
    var placeHolder: String?
    @Binding var inputText: String
    @State private var isHighlighted: Bool = false
    var errorText: String
    var masked: Bool? = false
    var countryCode: String?
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .textTitleStyle
            VStack(alignment: .leading, spacing: 1) {
                if masked ?? false {
                    SecureField(placeHolder ?? .init(), text: $inputText)
                        .focused($isFocused)
                        .textFieldStyle(TextFieldHighlightStyle())
                        .onChange(of: isFocused) { newValue in
                            isHighlighted = newValue
                        }
                } else {
                    HStack(alignment: .center) {
                        if !(countryCode?.isEmpty ?? true) {
                            Text(countryCode!)
                                .textValueStyle
                        }
                        TextField(placeHolder ?? .init(), text: $inputText, onEditingChanged: { editingChanged in
                            isHighlighted = editingChanged
                        })
                        .textFieldStyle(TextFieldHighlightStyle())
                    }
                }
                Rectangle()
                    .frame(height: isHighlighted ? 2 : 1)
                    .foregroundColor(isHighlighted ? .accent : .textfieldBorder)
                if !errorText.isEmpty {
                    ErrorLabel(text: errorText)
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct InputTextView: View {
    
    var title: String
    var placeHolder: String?
    @Binding var inputText: String
    @State private var isHighlighted: Bool = false
    var errorText: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .textTitleStyle
            VStack(alignment: .leading, spacing: 1) {
                TextEditor(text: $inputText)
                    .focused($isFocused)
                    .textFieldStyle(TextFieldHighlightStyle())
                    .frame(height: 40, alignment: .top)
                    .onChange(of: isFocused) { newValue in
                        isHighlighted = newValue
                    }
                Rectangle()
                    .frame(height: isHighlighted ? 2 : 1)
                    .foregroundColor(isHighlighted ? .accent : .textfieldBorder)
                if !errorText.isEmpty {
                    ErrorLabel(text: errorText)
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct preview : PreviewProvider {
    static var previews: some View {
        InputTextView(title: "Description",
                      placeHolder: "Placeholder",
                      inputText: .constant(""),
                      errorText: "Random")
    }
}

