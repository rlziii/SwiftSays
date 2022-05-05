import SwiftUI

@main
struct Application: App {
    @StateObject private var game = Game()

    var body: some Scene {
        WindowGroup {
            GameView(game: game)
        }
    }
}
