//
//  DetailEvolutionListCard.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import SwiftUI

struct DetailEvolutionListCard: View {
    @Environment(\.pokemonRepository) private var pokemonRepository

    let name: String
    @State private var pokemonDetails: PokemonViewModel?

    var body: some View {
        Group {
            if let pokemonDetails {
                NavigationLink {
                    DetailView(pokemonId: pokemonDetails.id)
                } label: {
                    HStack {
                        ListCardImage(
                            thumbnail: pokemonDetails.thumbnail,
                            showFallbackImage: pokemonDetails.thumbnail == nil
                        )
                            .frame(width: 80, height: 80)
                            .background(Color.cellBackground)

                        VStack(alignment: .leading) {
                            Text(pokemonDetails.idString)
                                .modifier(FontTheme.subHeadline)
                                .padding(.vertical, 2)
                                .padding(.horizontal, 6)
                                .background(RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.tint))
                            Text(pokemonDetails.name)
                                .modifier(FontTheme.headline)
                        }
                        Spacer()
                    }
                }
            } else {
                Color.clear.overlay {
                    ProgressView()
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .task { await loadDetails() }
    }
}

// MARK: - Data Loading
private extension DetailEvolutionListCard {
    func loadDetails() async {
        guard let pokemonRepository else { return }
        do {
            self.pokemonDetails = try await pokemonRepository
                .loadDetail(for: name)
        } catch {
            print("Error loading detail:", error)
        }
    }
}
