import SwiftUI

struct GameView: View {
    @ObservedObject var game: Game

    var body: some View {
        VStack {
            Spacer()

            StackedTileView(
                allowUserInput: game.allowUserInput,
                highlightedTile: game.highlightedTile,
                action: game.action
            )

            Text("Level: \(game.currentLevel)")
                .font(.title)

            Spacer()

            Button("Reset", action: game.resetGame)
        }
        .onAppear(perform: game.startGame)
        .alert("Game over!", isPresented: $game.gameIsFinished) {
            Button("Reset Game", action: game.resetGame)
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: .init())
    }
}
