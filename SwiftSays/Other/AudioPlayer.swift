import AVFAudio

class AudioPlayer {
    private let engine: AVAudioEngine
    private let sampler: AVAudioUnitSampler

    init?() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            self.engine = AVAudioEngine()
            self.sampler = AVAudioUnitSampler()
            engine.attach(sampler)
            engine.connect(sampler, to: engine.outputNode, format: nil)
            try engine.start()
        } catch {
            print("Could not initialize \(AudioPlayer.self). Error: \(error)")
            return nil
        }
    }

    @MainActor @Sendable
    func playSound(for tile: Tile) async throws {
        stopAllNotes()

        let note = midiNote(for: tile)

        sampler.startNote(note, withVelocity: 127, onChannel: 0)
        try await Task.sleep(seconds: 0.3)
        sampler.stopNote(note, onChannel: 0)
    }

    func stopAllNotes() {
        Tile.allCases.map(midiNote).forEach {
            sampler.stopNote($0, onChannel: 0)
        }
    }

    private func midiNote(for tile: Tile) -> UInt8 {
        // https://computermusicresource.com/midikeys.html
        switch tile {
        case .green:
            // E (3rd octave)
            return 64
        case .red:
            // C# (3rd octave)
            return 61
        case .yellow:
            // A (3rd octave)
            return 69
        case .blue:
            // E (2nd octave)
            return 52
        }
    }
}
