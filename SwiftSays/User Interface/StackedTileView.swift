import SwiftUI

struct StackedTileView: View {
    let allowUserInput: Bool
    let highlightedTile: Tile?
    let action: (Tile) async throws -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                TileView(
                    .green,
                    highlighted: highlightedTile == .green,
                    action: action
                )
                TileView(
                    .red,
                    highlighted: highlightedTile == .red,
                    action: action
                )
            }

            HStack(spacing: 0) {
                TileView(
                    .yellow,
                    highlighted: highlightedTile == .yellow,
                    action: action
                )
                TileView(
                    .blue,
                    highlighted: highlightedTile == .blue,
                    action: action
                )
            }
        }
        .clipShape(Circle())
        .overlay(CenterView())
        .padding(5)
        .disabled(!allowUserInput)
    }
}

struct StackedTileView_Previews: PreviewProvider {
    static var previews: some View {
        StackedTileView(
            allowUserInput: true,
            highlightedTile: .none,
            action: { _ in }
        )
    }
}
