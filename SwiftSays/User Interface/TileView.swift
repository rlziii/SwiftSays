import SwiftUI

struct TileView: View {
    let tile: Tile
    let highlighted: Bool
    let action: () async throws -> Void

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

    init(_ tile: Tile, highlighted: Bool, action: @escaping () async throws -> Void) {
        self.tile = tile
        self.highlighted = highlighted
        self.action = action
    }

    var body: some View {
        Button {
            Task {
                try await action()
            }
        } label: {
            color
                .scaledToFit()
                .overlay(highlighted ? Color.black.opacity(0.3) : nil)
        }
    }
}

struct TileView_Previews: PreviewProvider {
    static var previews: some View {
        TileView(
            .green,
            highlighted: false,
            action: {}
        )
        .previewLayout(.sizeThatFits)
        TileView(
            .red,
            highlighted: false,
            action: {}
        )
        .previewLayout(.sizeThatFits)
        TileView(
            .yellow,
            highlighted: false,
            action: {}
        )
        .previewLayout(.sizeThatFits)
        TileView(
            .blue,
            highlighted: false,
            action: {}
        )
        .previewLayout(.sizeThatFits)
    }
}
