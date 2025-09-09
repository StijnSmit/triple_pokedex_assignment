//
//  AudioPlayer.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import AVFoundation

final class AudioPlayer {
    private var player: AVPlayer?

    private var isPlaying: Bool {
        guard let player else { return false }
        return player.timeControlStatus == .playing
    }

    init() {
        let shared = AVAudioSession.sharedInstance()
        try? shared.setCategory(.playback)
        try? shared.setActive(true)
    }

    func play(_ url: URL) {
        if isPlaying {
            stop()
        }

        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
    }

    func stop() {
        player?.pause()
        player?.seek(to: .zero)
    }
}
