import SwiftUI

struct GameView: View {
    @StateObject var viewModel = GameViewModel()

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                TileView(
                    .green,
                    enabled: viewModel.allowUserInput,
                    tapped: { viewModel.tapped(tile: .green) }
                )
                TileView(
                    .red,
                    enabled: viewModel.allowUserInput,
                    tapped: { viewModel.tapped(tile: .red) }
                )
            }

            HStack(spacing: 0) {
                TileView(
                    .yellow,
                    enabled: viewModel.allowUserInput,
                    tapped: { viewModel.tapped(tile: .yellow) }
                )
                TileView(
                    .blue,
                    enabled: viewModel.allowUserInput,
                    tapped: { viewModel.tapped(tile: .blue) }
                )
            }
        }
        .onAppear {
            viewModel.startGame()
        }
    }
}

struct TileView: View {
    let tile: Tile
    let enabled: Bool
    let tapped: () -> Void

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

    init(_ tile: Tile, enabled: Bool, tapped: @escaping () -> Void) {
        self.tile = tile
        self.enabled = enabled
        self.tapped = tapped
    }

    var body: some View {
        Button(action: tapped) {
            color.aspectRatio(1.0, contentMode: .fit)
        }
        .disabled(!enabled)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
