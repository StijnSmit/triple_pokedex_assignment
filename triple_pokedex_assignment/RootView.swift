//
//  RootView.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import SwiftUI

struct DeeplinkItem: Identifiable {
    let pokemonId: Int

    var id: Int { pokemonId }
}

struct RootView: View {
    @Environment(\.hapticFeedback) private var haptic: UIImpactFeedbackGenerator

    @State private var deeplinkItem: DeeplinkItem?
    @State private var showDeeplinkError: Bool = false

    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Pokemons", image: "pokeball.fill", value: 0) {
                ListView(viewType: .all)
            }

            Tab("Favorites", image: "heart.fill", value: 1) {
                ListView(viewType: .favorites)
            }
        }
        .onChange(of: selectedTab) { _, _ in
            haptic.impactOccurred()
        }
        .onOpenURL { url in
            guard let id = Int(url.lastPathComponent) else {
                showDeeplinkError = true
                return
            }
            self.deeplinkItem = DeeplinkItem(pokemonId: id)
        }
        .fullScreenCover(item: $deeplinkItem) { deeplink in
            NavigationStack {
                DetailView(pokemonId: deeplink.id)
            }
        }
        .alert(isPresented: $showDeeplinkError) {
            Alert(
                title: Text("Invalid link"),
                message: Text("The link you opened seems to be broken, try creating a new one!")
            )
        }
    }
}
