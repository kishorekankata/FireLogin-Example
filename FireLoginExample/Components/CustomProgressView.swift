
import SwiftUI

struct CustomProgressView: View {
    var text: String
    var body: some View {
        ZStack {
            ProgressView(label: {
                Text(text)
                    .textValueStyle
                    .foregroundColor(.accent)
            })
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 50)
                .background(VisualEffectView(effect: UIBlurEffect(style: .systemMaterial)).opacity(0.6))
                .progressViewStyle(CircularProgressViewStyle(tint: .accent))
        }
    }
}


struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
