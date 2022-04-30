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
                    tapped: { try await viewModel.tapped(tile: .green) }
                )
                TileView(
                    .red,
                    enabled: $viewModel.allowUserInput,
                    highlighted: highlightedTile == .red,
                    tapped: { try await viewModel.tapped(tile: .red) }
                )
            }

            HStack(spacing: 0) {
                TileView(
                    .yellow,
                    enabled: $viewModel.allowUserInput,
                    highlighted: highlightedTile == .yellow,
                    tapped: { try await viewModel.tapped(tile: .yellow) }
                )
                TileView(
                    .blue,
                    enabled: $viewModel.allowUserInput,
                    highlighted: highlightedTile == .blue,
                    tapped: { try await viewModel.tapped(tile: .blue) }
                )
            }
        }
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

    private func sleep(seconds: Double) async {

    }
}

struct TileView: View {
    let tile: Tile
    @Binding var enabled: Bool
    let highlighted: Bool
    let tapped: () async throws -> Void

    private var color: Color {
        switch tile {
        case .green:
            return .green
        case .red:
            return .red
        case .yellow:
            return .yellow
        case .blue:
            return .blue
        }
    }

    init(_ tile: Tile, enabled: Binding<Bool>, highlighted: Bool, tapped: @escaping () async throws -> Void) {
        self.tile = tile
        self._enabled = enabled
        self.highlighted = highlighted
        self.tapped = tapped
    }

    var body: some View {
        Button {
            Task {
                try await tapped()
            }
        } label: {
            color
                .scaledToFit()
                .overlay(highlighted ? Color.black.opacity(0.3) : nil)
        }
        .disabled(!enabled)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
