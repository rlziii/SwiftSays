import AVFAudio

class AudioPlayer {
    private let engine = AVAudioEngine()
    private let sampler = AVAudioUnitSampler()

    init() {
        engine.attach(sampler)
        engine.connect(sampler, to: engine.outputNode, format: nil)
        try! engine.start()
    }

    func playSound(for tile: Tile) {
        Task { @MainActor [sampler] in
            let note: UInt8 = {
                switch tile {
                case .green:
                    return 64 // E
                case .red:
                    return 61 // C#
                case .yellow:
                    return 69 // A
                case .blue:
                    return 52 // E (octacve lower)
                }
            }()

            sampler.startNote(note, withVelocity: 64, onChannel: 0)
            try await Task.sleep(nanoseconds: 300_000_000) // 0.3s
            sampler.stopNote(note, onChannel: 0)
        }
    }
}
