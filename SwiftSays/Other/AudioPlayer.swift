import AVFAudio

class AudioPlayer {
    private let engine = AVAudioEngine()
    private let sampler = AVAudioUnitSampler()

    init() {
        try! AVAudioSession.sharedInstance().setCategory(.playback)

        engine.attach(sampler)
        engine.connect(sampler, to: engine.outputNode, format: nil)
        try! engine.start()
    }

    func playSound(for tile: Tile) {
        Task { @MainActor [sampler] in
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

            sampler.startNote(note, withVelocity: 64, onChannel: 0)
            try await Task.sleep(seconds: 0.3)
            sampler.stopNote(note, onChannel: 0)
        }
    }
}
