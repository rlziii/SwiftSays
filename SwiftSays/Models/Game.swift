import Foundation

@MainActor
class Game: ObservableObject {
    // MARK: - Public Properties

    @Published private(set) var allowUserInput = false
    @Published private(set) var highlightedTile: Tile?
    @Published var isPlaying = false
    @Published var showGameOver = false

    var score: Int { max(0, gameInput.count - 1) }

    // MARK: - Private Properties

    private var gameInput: [Tile] = []
    private var userInput: [Tile] = []
    private let audioPlayer: AudioPlayer

    // MARK: - Initialization

    init() {
        guard let audioPlayer = AudioPlayer() else {
            fatalError("Could not create \(AudioPlayer.self) for \(Game.self).")
        }

        self.audioPlayer = audioPlayer
    }

    // MARK: - Public Methods

    func startGame() {
        isPlaying = true
        advanceGameLoop()
    }

    func resetGame() {
        gameInput = []
        userInput = []
        isPlaying = false
        allowUserInput = false
    }

    func action(for tile: Tile) async throws {
        try await audioPlayer.playSound(for: tile)
        userInput.append(tile)
        advanceGameLoop()
    }

    // MARK: - Private Methods

    private func advanceGameLoop() {
        guard isPlaying else {
            return
        }

        if gameInput.isEmpty {
            nextGameInput()
        } else if userInput.isEmpty {
            // Waiting on user input...
        } else if gameInput.count != userInput.count {
            checkCurrentInput()
        } else if gameInput.count == userInput.count {
            checkCurrentInput()
            nextGameInput()
        } else {
            assertionFailure("Unexpected state.")
        }
    }

    private func nextGameInput() {
        guard isPlaying else {
            return
        }

        userInput = []

        let tile = Tile.allCases.randomElement()!
        gameInput.append(tile)

        Task { try await highlightGameInputs() }

        advanceGameLoop()
    }

    private func highlightGameInputs() async throws {
        try await Task.sleep(seconds: 0.5)

        allowUserInput = false
        for tile in gameInput {
            highlightedTile = tile
            try await audioPlayer.playSound(for: tile)
            try await Task.sleep(seconds: 0.3)
            highlightedTile = nil
            try await Task.sleep(seconds: 0.1)
        }
        allowUserInput = true
    }

    private func checkCurrentInput() {
        let index = userInput.endIndex - 1

        guard userInput.indices.contains(index) && gameInput.indices.contains(index) else {
            assertionFailure("Unexpected state.")
            return
        }

        if userInput[index] != gameInput[index] {
            isPlaying = false
            showGameOver = true
        }
    }
}
