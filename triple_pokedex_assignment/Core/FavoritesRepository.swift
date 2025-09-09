//
//  FavoritesRepository.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import Foundation
import SwiftData

enum FavoritesRepositoryError: Error {
    case pokemonNotFound
}

@MainActor
final class FavoritesRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func favorite(for pokemonId: Int) throws {
        guard let pokemon = try fetchPokemon(for: pokemonId) else {
            return
        }
        pokemon.isFavorite = true
        try modelContext.save()
    }

    func unfavorite(for pokemonId: Int) throws {
        guard let pokemon = try fetchPokemon(for: pokemonId) else {
            return
        }
        pokemon.isFavorite = false
        try modelContext.save()
    }

    func isFavorited(for pokemonId: Int) throws -> Bool {
        guard let pokemon = try fetchPokemon(for: pokemonId) else {
            return false
        }

        return pokemon.isFavorite
    }

    private func fetchPokemon(for pokemonId: Int) throws -> PokemonEntity? {
        if let pokemon = try modelContext.fetch(
            FetchDescriptor<PokemonEntity>(predicate: #Predicate { $0.id == pokemonId })
        ).first {
            return pokemon
        }

        throw FavoritesRepositoryError.pokemonNotFound
    }
}
