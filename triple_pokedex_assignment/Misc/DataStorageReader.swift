//
//  DataStorageReader.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import Foundation
import SwiftData

@ModelActor
actor DataStorageReader {

    /// Stores models into SwiftData context and persists them.
    func store<M: PersistentModel>(_ models: [M]) throws {
        models.forEach { modelContext.insert($0) }
    }

    /// Fetches all objects of type `M` sorted by the given descriptor.
    func fetch<M: PersistentModel>(sortBy: SortDescriptor<M>) throws -> [M] {
        try modelContext.fetch(FetchDescriptor<M>(sortBy: [sortBy]))
    }

    /// Generic fetch helper for single object with a predicate.
    private func fetchOne<M: PersistentModel>(_ descriptor: FetchDescriptor<M>) throws -> M? {
        try modelContext.fetch(descriptor).first
    }

    // MARK: - Pokémon specific helpers
    func fetchPokemon(id: Int) throws -> PokemonEntity? {
        try fetchOne(FetchDescriptor(predicate: #Predicate { $0.id == id }))
    }

    func fetchPokemon(name: String) throws -> PokemonEntity? {
        try fetchOne(FetchDescriptor(predicate: #Predicate { $0.name == name }))
    }

    func fetchPokemonDetail(id: Int) throws -> PokemonDetailEntity? {
        try fetchOne(FetchDescriptor(predicate: #Predicate { $0.id == id }))
    }

    func fetchPokemonDetail(name: String) throws -> PokemonDetailEntity? {
        try fetchOne(FetchDescriptor(predicate: #Predicate { $0.name == name }))
    }

    func fetchEvolution(id: Int) throws -> EvolutionChainEntity? {
        try fetchOne(FetchDescriptor(predicate: #Predicate { $0.id == id }))
    }
}
