import SwiftUI

struct GameView: View {
    @StateObject var viewModel = GameViewModel()

    var body: some View {
        VStack {
            Spacer()

            StackedTileView(
                allowUserInput: viewModel.allowUserInput,
                highlightedTile: viewModel.highlightedTile,
                action: viewModel.action
            )

            Text("Level: \(viewModel.currentLevel)")
                .font(.title)

            Spacer()

            Button("Reset", action: viewModel.resetGame)
        }
        .onAppear(perform: viewModel.startGame)
        .alert("Game over!", isPresented: $viewModel.gameIsFinished) {
            Button("Reset Game", action: viewModel.resetGame)
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
