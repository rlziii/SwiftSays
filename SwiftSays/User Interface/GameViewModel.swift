import Foundation

class GameViewModel: ObservableObject {
    // MARK: - Public Properties

    @Published private(set) var gameInput: [Tile] = []
    @Published private(set) var allowUserInput = false
    @Published private(set) var highlightedTile: Tile?
    @Published var gameIsFinished = false

    var currentLevel: Int { gameInput.count - 1 }

    // MARK: - Private Properties

    private var userInput: [Tile] = []
    private let audioPlayer: AudioPlayer

    // MARK: - Initialization
    init() {
        guard let audioPlayer = AudioPlayer() else {
            fatalError("Could not create \(AudioPlayer.self) for \(GameViewModel.self).")
        }

        self.audioPlayer = audioPlayer
    }

    // MARK: - Public Methods

    func startGame() {
        nextGameLoop()
    }

    func resetGame() {
        gameInput = []
        userInput = []
        gameIsFinished = false
        allowUserInput = false

        nextGameLoop()
    }

    func action(for tile: Tile) async throws {
        try await audioPlayer.playSound(for: tile)
        userInput.append(tile)
        nextGameLoop()
    }

    // MARK: - Private Methods

    private func nextGameLoop() {
        guard !gameIsFinished else {
            return
        }

        if gameInput.isEmpty {
            randomGameInput()
        } else if userInput.isEmpty {
            // Do nothing.
        } else if gameInput.count != userInput.count {
            checkCurrentInput()
        } else if gameInput.count == userInput.count {
            checkCurrentInput()

            if !gameIsFinished {
                randomGameInput()
            }
        } else {
            assertionFailure("Unexpected state.")
        }
    }

    private func randomGameInput() {
        userInput = []

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
            gameIsFinished = true
        }
    }
}
