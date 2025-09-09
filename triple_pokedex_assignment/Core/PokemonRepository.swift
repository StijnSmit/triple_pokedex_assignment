//
//  PokemonRepository.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import Foundation
import SwiftData
import PokedexAPI

actor PokemonRepository {
    private var detailTasks: [Int: Task<PokemonViewModel, Error>] = [:]
    private var evolutionTasks: [Int: Task<EvolutionChainEntity, Error>] = [:]
    private let storageReader: DataStorageReader
    private let networkService: PokedexAPI

    init(modelContext: ModelContext, networkService: PokedexAPI = PokedexAPI()) {
        self.storageReader = DataStorageReader(modelContainer: modelContext.container)
        self.networkService = networkService
    }

    // MARK: - Pokémon Detail
    func loadDetail(for id: Int) async throws -> PokemonViewModel {
        if let cached = try? await storageReader.fetchPokemonDetail(id: id) {
            return PokemonViewModel(pokemonDetail: cached)
        }
        return try await remotelyLoadDetail(for: id)
    }

    func loadDetail(for name: String) async throws -> PokemonViewModel {
        if let cached = try? await storageReader.fetchPokemonDetail(name: name) {
            return PokemonViewModel(pokemonDetail: cached)
        }
        guard let pokemon = try? await storageReader.fetchPokemon(name: name) else {
            throw PokemonRepositoryError.pokemonNotFound
        }
        return try await remotelyLoadDetail(for: pokemon.id)
    }

    private func remotelyLoadDetail(for id: Int) async throws -> PokemonViewModel {
        if let task = detailTasks[id] { return try await task.value }
        let task = Task { () throws -> PokemonViewModel in
            defer { detailTasks[id] = nil }

            do {
                let response = try await networkService.fetchPokemon(id: id)

                let detail = PokemonDetailEntity(
                    id: id,
                    name: response.name,
                    baseExperience: response.baseExperience,
                    height: response.height,
                    weight: response.weight,
                    sprites: PokemonSpriteEntity(
                        front: response.sprites.front,
                        back: response.sprites.back,
                        homeArtworkFront: response.sprites.homeArtworkFront,
                        officialArtworkFront: response.sprites.officialArtworkFront
                    ),
                    cries: PokemonCryEntity(
                        latest: response.cries.latest,
                        legacy: response.cries.legacy
                    ),
                    abilities: response.abilities.map {
                        PokemonAbilityEntity(isHidden: $0.isHidden, slot: $0.slot, name: $0.name)
                    },
                    stats: response.stats.map {
                        PokemonStatEntity(baseStat: $0.baseStat, name: $0.name)
                    },
                    types: response.types.map {
                        PokemonTypeEntity(name: $0.name, slot: $0.slot)
                    },
                    speciesId: response.speciesUrl.split(separator: "/").last.flatMap { Int($0) },
                    species: nil
                )

                try await storageReader.store([detail])
                return PokemonViewModel(pokemonDetail: detail)
            } catch {
                throw PokemonRepositoryError.pokemonNotFound
            }
        }

        detailTasks[id] = task
        return try await task.value
    }

    // MARK: - Evolution
    func loadEvolution(for pokemonId: Int) async throws -> EvolutionChainEntity? {
        guard let pokemonDetail = try? await storageReader.fetchPokemonDetail(id: pokemonId) else {
            throw PokemonRepositoryError.pokemonNotFound
        }

        if let task = evolutionTasks[pokemonId] { return try await task.value }

        var evolutionChainId: Int?

        if let species = pokemonDetail.species {
            evolutionChainId = species.evolutionId
        } else {
            let response = try await networkService.fetchSpecies(id: pokemonDetail.speciesId ?? pokemonId)
            let species = SpeciesEntity(id: response.id, evolutionUrlString: response.evolutionUrl)
            pokemonDetail.species = species
            try await storageReader.store([pokemonDetail])
            evolutionChainId = species.evolutionId
        }

        guard let evolutionChainId else { return nil }

        if let cached = try? await storageReader.fetchEvolution(id: evolutionChainId) {
            return cached
        }

        let task = Task { () throws -> EvolutionChainEntity in
            defer { evolutionTasks[pokemonId] = nil }

            let response = try await networkService.fetchEvolution(id: evolutionChainId)

            var link: EvolutionChainLink? = response.chain
            var position = 0
            let evolutionChain = EvolutionChainEntity(id: response.id, evolutions: [])
            while let evolution = link {
                if let speciesId = evolution.pokemonSpeciesUrl.split(separator: "/").last.flatMap({ Int($0) }) {
                    let entity = EvolutionChainLinkEntity(
                            pokemonName: evolution.pokemonName,
                            position: position,
                            speciesId: speciesId)
                    entity.chain = evolutionChain
                    position += 1
                }
                link = evolution.evolvesTo.first
            }

            try await storageReader.store([evolutionChain])
            return evolutionChain
        }
        evolutionTasks[pokemonId] = task
        return try await task.value
    }
}

// MARK: - Errors
enum PokemonRepositoryError: Error {
    case pokemonNotFound
    case noEvolutionAttached
}
