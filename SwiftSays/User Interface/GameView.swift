import SwiftUI

struct GameView: View {
    @StateObject var viewModel = GameViewModel()
    @State private var highlightedTile: Tile?

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                TileView(
                    .green,
                    enabled: $viewModel.allowUserInput,
                    highlighted: highlightedTile == .green,
                    action: { try await viewModel.tapped(tile: .green) }
                )
                TileView(
                    .red,
                    enabled: $viewModel.allowUserInput,
                    highlighted: highlightedTile == .red,
                    action: { try await viewModel.tapped(tile: .red) }
                )
            }

            HStack(spacing: 0) {
                TileView(
                    .yellow,
                    enabled: $viewModel.allowUserInput,
                    highlighted: highlightedTile == .yellow,
                    action: { try await viewModel.tapped(tile: .yellow) }
                )
                TileView(
                    .blue,
                    enabled: $viewModel.allowUserInput,
                    highlighted: highlightedTile == .blue,
                    action: { try await viewModel.tapped(tile: .blue) }
                )
            }
        }
        .clipShape(Circle())
        .overlay(CenterView())
        .padding(5)
        .onAppear {
            viewModel.startGame()
        }
        .onChange(of: viewModel.gameInput) { gameInput in
            Task {
                try await Task.sleep(seconds: 0.5)

                viewModel.allowUserInput = false
                for tile in gameInput {
                    highlightedTile = tile
                    try await viewModel.playSound(for: tile)
                    try await Task.sleep(seconds: 0.3)
                    highlightedTile = nil
                    try await Task.sleep(seconds: 0.1)
                }
                viewModel.allowUserInput = true
            }
        }
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
