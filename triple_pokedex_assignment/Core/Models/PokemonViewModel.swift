//
//  PokemonViewModel.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import SwiftUI

/// Protocol for Pokémon view models providing display-ready Pokémon data.
protocol PokemonViewModelProtocol {
    var thumbnail: String? { get }
    var image: String? { get }
    var types: [PokemonType] { get }
    var abilities: String { get }
    var name: String { get }
    var baseExperience: String { get }
    var stats: [PokemonStat] { get }
    var height: String { get }
    var weight: String { get }
    var id: Int { get }
    var idString: String { get }
    var cry: String? { get }
}

// MARK: -
/// ViewModel providing formatted and display-ready data for a single Pokémon.
struct PokemonViewModel: PokemonViewModelProtocol, Sendable {
    var thumbnail: String?
    var image: String?
    var types: [PokemonType]
    var typesString: String
    var abilities: String
    var name: String
    var baseExperience: String
    var stats: [PokemonStat]
    var height: String
    var weight: String
    var id: Int
    var idString: String
    var cry: String?

    /// Initializes the ViewModel with Pokémon details.
    /// - Parameter pokemonDetail: The detailed Pokémon model.
    init(pokemonDetail: PokemonDetailEntity) {
        self.thumbnail = pokemonDetail.sprites.front
        self.image = pokemonDetail.sprites.officialArtworkFront
            ?? pokemonDetail.sprites.homeArtworkFront
            ?? pokemonDetail.sprites.front
        self.types = pokemonDetail.types
            .sorted { $0.slot < $1.slot }
            .map { PokemonType(from: $0.name) }
        self.typesString = pokemonDetail.types
            .sorted { $0.slot < $1.slot }
            .map { $0.name.capitalized }
            .joined(separator: ", ")
        self.abilities = pokemonDetail.abilities
            .sorted { $0.slot < $1.slot }
            .map { $0.name.capitalized }
            .joined(separator: ", ")
        self.name = pokemonDetail.name.capitalized
        self.baseExperience = "\(pokemonDetail.baseExperience) XP"
        self.stats = pokemonDetail.stats
            .map { PokemonStat(name: $0.name,value: $0.baseStat) }
        self.height = "\(Double(pokemonDetail.height) / 10.0) m"
        self.weight = "\(Double(pokemonDetail.weight) / 10.0) kg"
        self.id = pokemonDetail.id
        self.idString = String(format: "%03d", pokemonDetail.id)
        self.cry = pokemonDetail.cries.latest ?? pokemonDetail.cries.legacy
    }
}

// MARK: - Equatable
extension PokemonViewModel: Equatable {
    static func == (lhs: PokemonViewModel, rhs: PokemonViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
