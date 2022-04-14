import Combine

class GameViewModel: ObservableObject {
    @Published private(set) var gameInput: [Tile] = []
    @Published private var gameIsFinished = false
    @Published private(set) var allowUserInput = false
    private var userInput: [Tile] = []

    private let audioPlayer = AudioPlayer()

    func startGame() {
        nextGameLoop()
    }

    func tapped(tile: Tile) {
        playSound(for: tile)
        userInput.append(tile)
        nextGameLoop()
    }

    func playSound(for tile: Tile) {
        audioPlayer.playSound(for: tile)
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
