import SwiftUI

struct TileView: View {
    let tile: Tile
    @Binding var enabled: Bool
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

    init(_ tile: Tile, enabled: Binding<Bool>, highlighted: Bool, action: @escaping () async throws -> Void) {
        self.tile = tile
        self._enabled = enabled
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
        .disabled(!enabled)
    }
}

struct TileView_Previews: PreviewProvider {
    static var previews: some View {
        TileView(
            .green,
            enabled: .constant(true),
            highlighted: false,
            action: {}
        )
        .previewLayout(.sizeThatFits)
        TileView(
            .red,
            enabled: .constant(true),
            highlighted: false,
            action: {}
        )
        .previewLayout(.sizeThatFits)
        TileView(
            .yellow,
            enabled: .constant(true),
            highlighted: false,
            action: {}
        )
        .previewLayout(.sizeThatFits)
        TileView(
            .blue,
            enabled: .constant(true),
            highlighted: false,
            action: {}
        )
        .previewLayout(.sizeThatFits)
    }
}
