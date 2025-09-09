//
//  triple_pokedex_assignmentApp.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import SwiftUI
import SwiftData
import PokedexAPI

@main
struct triple_pokedex_assignmentApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PokemonEntity.self,
            PokemonDetailEntity.self,
            EvolutionChainEntity.self,
            SpeciesEntity.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .onAppear {
                    applyNavigationBarStyling()
                }
                .task {
                    await PokemonSyncService().loadAllPokemons(context: sharedModelContainer.mainContext)
                }
                .tint(Color.tint)
                .environment(
                    \.favoritesRepository,
                     FavoritesRepository(
                        modelContext: sharedModelContainer.mainContext
                     )
                )
                .environment(\.pokemonRepository, PokemonRepository(
                    modelContext: sharedModelContainer.mainContext))
        }
        .modelContainer(sharedModelContainer)
    }
}
