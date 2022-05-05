import Foundation

class GameViewModel: ObservableObject {
    @Published private(set) var gameInput: [Tile] = []
    @Published private(set) var allowUserInput = false
    @Published private(set) var highlightedTile: Tile?
    @Published var gameIsFinished = false

    var currentLevel: Int { gameInput.count - 1 }

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

    func action(for tile: Tile) async throws {
        try await playSound(for: tile)
        userInput.append(tile)
        nextGameLoop()
    }

    func resetGame() {
        gameInput = []
        userInput = []
        gameIsFinished = false
        allowUserInput = false

        nextGameLoop()
    }

    private func nextGameLoop() {
        guard !gameIsFinished else {
            return
        }

        if gameInput.isEmpty {
            randomGameInput()
        } else {
            allowUserInput = true
            checkCurrentInput()
        }
    }

    private func playSound(for tile: Tile) async throws {
        try await audioPlayer.playSound(for: tile)
    }

    private func clearUserInput() {
        userInput = []
    }

    private func randomGameInput() {
        clearUserInput()

        let tile = Tile.allCases.randomElement()!
        gameInput.append(tile)

        Task { try await highlightGameInputs() }

        nextGameLoop()
    }

    @MainActor
    private func highlightGameInputs() async throws {
        try await Task.sleep(seconds: 0.5)

        allowUserInput = false
        for tile in gameInput {
            highlightedTile = tile
            try await playSound(for: tile)
            try await Task.sleep(seconds: 0.3)
            highlightedTile = nil
            try await Task.sleep(seconds: 0.1)
        }
        allowUserInput = true
    }

    private func checkCurrentInput() {
        let index = userInput.endIndex - 1

        guard userInput.indices.contains(index) && gameInput.indices.contains(index) else {
            return
        }

        if userInput[index] != gameInput[index] {
            endGame()
        }

        if !gameIsFinished, userInput.endIndex == gameInput.endIndex {
            randomGameInput()
        }
    }

    private func endGame() {
        gameIsFinished = true
    }
}
