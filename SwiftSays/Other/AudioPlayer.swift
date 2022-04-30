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
        // https://computermusicresource.com/midikeys.html
        let note: UInt8 = {
            switch tile {
            case .green:
                return 64 // E (3rd octave)
            case .red:
                return 61 // C# (3rd octave)
            case .yellow:
                return 69 // A (3rd octave)
            case .blue:
                return 52 // E (2nd octave)
            }
        }()

        sampler.startNote(note, withVelocity: 127, onChannel: 0)
        try await Task.sleep(seconds: 0.3)
        sampler.stopNote(note, onChannel: 0)
    }
}
