import SwiftUI

struct CenterView: View {
    var body: some View {
        Circle()
            .scale(0.3)
            .overlay {
                Image(systemName: "swift")
                    .font(.largeTitle)
                    .foregroundColor(.primary)
                    .colorInvert()
            }
    }
}

struct CenterView_Previews: PreviewProvider {
    static var previews: some View {
        CenterView()
            .previewLayout(.sizeThatFits)
    }
}
