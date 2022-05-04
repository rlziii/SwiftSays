import Foundation

class GameViewModel: ObservableObject {
    @Published private(set) var gameInput: [Tile] = []
    @Published var gameIsFinished = false
    @Published var allowUserInput = false

    var currentCount: Int { gameInput.count - 1 }

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
        } else {
            allowUserInput = true
            checkCurrentInput()
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
