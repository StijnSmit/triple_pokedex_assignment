//
//  PokemonRepositoryKey.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import SwiftUI

private struct PokemonRepositoryKey: EnvironmentKey {
    static let defaultValue: PokemonRepository? = nil
}

extension EnvironmentValues {
    var pokemonRepository: PokemonRepository? {
        get { self[PokemonRepositoryKey.self] }
        set { self[PokemonRepositoryKey.self] = newValue }
    }
}
