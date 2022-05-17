import SwiftUI

struct TitleView: View {
    var body: some View {
        Text("Swift Says")
            .font(.largeTitle)
            .dynamicTypeSize(.accessibility5)
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
            .previewLayout(.sizeThatFits)
    }
}
