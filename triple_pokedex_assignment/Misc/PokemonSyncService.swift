//
//  PokemonSyncService.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import Foundation
import SwiftData
import PokedexAPI

/// Handles syncing Pokémon list data between the API and local SwiftData store.
struct PokemonSyncService {

    private let api: PokedexAPI

    init(api: PokedexAPI = PokedexAPI()) {
        self.api = api
    }

    /// Fetches the complete Pokémon list from the API and syncs it into SwiftData.
    func loadAllPokemons(context: ModelContext) async {
        do {
            // Fetch first batch
            let firstFetch = try await api.fetchList()

            // Fetch remaining batch
            let offset = firstFetch.results.count
            let limit = firstFetch.count - offset
            let secondFetch = try await api.fetchList(offset: offset, limit: limit)

            // Merge results and sync
            let allFetched = firstFetch.results + secondFetch.results
            try await syncItems(from: allFetched, context: context)
        } catch {
            fatalError("Failed to load Pokémon list: \(error.localizedDescription)")
        }
    }

    /// Syncs API Pokémon list items into the SwiftData context, avoiding duplicates.
    private func syncItems(from networkItems: [PokemonListItem], context: ModelContext) async throws {
        let existingItems = try context.fetch(FetchDescriptor<PokemonEntity>())
        let existingIds = Set(existingItems.map { $0.id })

        // Only add new ones with valid IDs
        let newItems = networkItems.compactMap { dto -> PokemonListItem? in
            guard let id = dto.id, !existingIds.contains(id) else { return nil }
            return dto
        }

        for dto in newItems {
            if let id = dto.id {
                context.insert(PokemonEntity(id: id, name: dto.name))
            }
        }

        if !newItems.isEmpty {
            try context.save()
        }
    }
}
