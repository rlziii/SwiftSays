import SwiftUI

struct CenterView: View {
    var body: some View {
        Circle()
            .scale(0.3)
            .fill(.black)
            .overlay {
                Image(systemName: "swift")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .dynamicTypeSize(.accessibility5)
            }
    }
}

struct CenterView_Previews: PreviewProvider {
    static var previews: some View {
        CenterView()
            .previewLayout(.sizeThatFits)
            .scaledToFit()
    }
}
