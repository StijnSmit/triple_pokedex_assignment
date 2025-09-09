//
//  AudioPlayerKey.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import SwiftUI

private struct AudioPlayerKey: EnvironmentKey {
    static let defaultValue: AudioPlayer = AudioPlayer()
}

extension EnvironmentValues {
    var audioPlayer: AudioPlayer {
        get { self[AudioPlayerKey.self] }
        set { self[AudioPlayerKey.self] = newValue }
    }
}
