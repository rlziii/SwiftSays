import SwiftUI

struct GameView: View {
    @ObservedObject var game: Game

    var body: some View {
        VStack {
            Spacer()

            StackedTileView(
                highlightedTile: game.highlightedTile,
                action: game.action
            )
            .overlay(CenterView())
            .disabled(!game.allowUserInput)

            Text("Score: \(game.score)")
                .font(.title)

            Spacer()

            Button("Reset", action: game.resetGame)
                .buttonStyle(.borderedProminent)
                .cornerRadius(.infinity)
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
