import SwiftUI

struct BottomButtonView: View {
    let isPlaying: Bool
    let startAction: () -> Void
    let resetAction: () -> Void

    private var title: LocalizedStringKey {
        isPlaying ? "Reset" : "Start Game"
    }

    private var backgroundColor: Color {
        isPlaying ? .red : .blue
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title3)
                .bold()
                .padding(.horizontal)

        }
        .buttonStyle(.bordered)
        .foregroundColor(.white)
        .background(backgroundColor)
        .cornerRadius(.infinity)
    }

    private func action() {
        isPlaying ? resetAction() : startAction()
    }
}

struct BottomButtonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            BottomButtonView(
                isPlaying: true,
                startAction: {},
                resetAction: {}
            )
            BottomButtonView(
                isPlaying: false,
                startAction: {},
                resetAction: {}
            )
        }
        .previewLayout(.sizeThatFits)
    }
}
