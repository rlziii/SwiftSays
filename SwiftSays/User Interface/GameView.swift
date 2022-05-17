import SwiftUI

struct GameView: View {
    @ObservedObject var game: Game

    var body: some View {
        VStack {
            TitleView()

            Spacer()

            StackedTileView(
                highlightedTile: game.highlightedTile,
                action: game.action
            )
            .overlay(CenterView())
            .disabled(!game.allowUserInput)

            Spacer()

            ScoreView(game.score)

            BottomButtonView(
                isPlaying: $game.isPlaying,
                startAction: game.startGame,
                resetAction: game.resetGame
            )
        }
        .alert("Game over!", isPresented: $game.showGameOver) {
            Button("OK", action: game.resetGame)
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: .init())
    }
}
