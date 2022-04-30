import Foundation

class GameViewModel: ObservableObject {
    @Published private(set) var gameInput: [Tile] = []
    @Published var gameIsFinished = false
    @Published var allowUserInput = false
    private var userInput: [Tile] = []

    private let audioPlayer: AudioPlayer

    init() {
        guard let audioPlayer = AudioPlayer() else {
            fatalError("Could not create \(AudioPlayer.self) for \(GameViewModel.self).")
        }

        self.audioPlayer = audioPlayer
    }

    func startGame() {
        nextGameLoop()
    }

    func tapped(tile: Tile) async throws {
        try await playSound(for: tile)
        userInput.append(tile)
        nextGameLoop()
    }

    func playSound(for tile: Tile) async throws {
        try await audioPlayer.playSound(for: tile)
    }

    func resetGame() {
        gameInput = []
        gameIsFinished = false
        allowUserInput = false
        userInput = []
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
        gameInput.append(tile)

        nextGameLoop()
    }

    private func checkOutcome() {
        if gameInput == userInput {
            randomGameInput()
        } else {
            endGame()
        }
    }

    private func endGame() {
        gameIsFinished = true
    }
}
