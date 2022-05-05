import SwiftUI

struct GameView: View {
    @StateObject var viewModel = GameViewModel()

    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    TileView(
                        .green,
                        highlighted: viewModel.highlightedTile == .green,
                        action: { try await viewModel.action(for: .green) }
                    )
                    TileView(
                        .red,
                        highlighted: viewModel.highlightedTile == .red,
                        action: { try await viewModel.action(for: .red) }
                    )
                }

                HStack(spacing: 0) {
                    TileView(
                        .yellow,
                        highlighted: viewModel.highlightedTile == .yellow,
                        action: { try await viewModel.action(for: .yellow) }
                    )
                    TileView(
                        .blue,
                        highlighted: viewModel.highlightedTile == .blue,
                        action: { try await viewModel.action(for: .blue) }
                    )
                }
            }
            .clipShape(Circle())
            .overlay(CenterView())
            .padding(5)
            .disabled(!viewModel.allowUserInput)

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
