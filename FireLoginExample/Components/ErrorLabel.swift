//
//  ErrorLabel.swift
//

import SwiftUI

struct ErrorLabel: View {
    var text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(.errorColor)
            .textValueStyle
    }
}

struct ErrorLabel_Previews: PreviewProvider {
    static var previews: some View {
        ErrorLabel(text: "Im error")
    }
}
