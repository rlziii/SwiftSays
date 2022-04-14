import AVFoundation
import SwiftUI

enum Tile: CaseIterable {
    case green
    case red
    case yellow
    case blue
}

enum GameState {
    case winner
    case loser
}

class AudioPlayer {
    private let engine = AVAudioEngine()
    private let sampler = AVAudioUnitSampler()

    init() {
        engine.attach(sampler)
        engine.connect(sampler, to: engine.outputNode, format: nil)
        try! engine.start()
    }

    func playSound(for tile: Tile) {
        Task { @MainActor [sampler] in
            let note: UInt8 = {
                switch tile {
                case .green:
                    return 64 // E
                case .red:
                    return 61 // C#
                case .yellow:
                    return 69 // A
                case .blue:
                    return 52 // E (octacve lower)
                }
            }()

            sampler.startNote(note, withVelocity: 64, onChannel: 0)
            try await Task.sleep(nanoseconds: 300_000_000) // 0.3s
            sampler.stopNote(note, onChannel: 0)
        }
    }
}

class GameViewModel: ObservableObject {
    @Published private(set) var gameInput: [Tile] = []
    @Published private(set) var gameIsFinished = false
    @Published private(set) var allowUserInput = false
    private(set) var userInput: [Tile] = []

    private let audioPlayer = AudioPlayer()

    func startGame() {
        nextGameLoop()
    }

    func tapped(tile: Tile) {
        audioPlayer.playSound(for: tile)
        userInput.append(tile)
        nextGameLoop()
    }

    private func nextGameLoop() {
        guard !gameIsFinished else {
            return
        }

        if gameInput.isEmpty {
            randomGameInput()
        } else if userInput.count == gameInput.count {
            checkOutcome()
        } else {
            allowUserInput = true
        }
    }

    private func clearUserInput() {
        userInput = []
    }

    private func randomGameInput() {
        clearUserInput()

        let tile = Tile.allCases.randomElement()!
        print(tile)
        gameInput.append(tile)

        nextGameLoop()
    }

    private func checkOutcome() {
        // Can this just check last element?
        if gameInput == userInput {
            allowUserInput = false
            randomGameInput()
        } else {
            endGame()
        }
    }

    private func endGame() {
        gameIsFinished = true
        allowUserInput = false
        print("Game over!")
    }
}

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
