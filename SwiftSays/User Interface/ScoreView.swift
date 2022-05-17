import SwiftUI

struct ScoreView: View {
    private let score: Int

    init(_ score: Int) {
        self.score = score
    }

    var body: some View {
        Text("Score: \(score)")
            .font(.title)
            .monospacedDigit()
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView(123)
            .previewLayout(.sizeThatFits)
    }
}
