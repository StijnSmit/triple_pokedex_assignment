//
//  ListCard.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//
import SwiftUI

struct ListCard: View {
    @Environment(\.favoritesRepository) private var favoritesRepository
    @Environment(\.pokemonRepository) private var pokemonRepository

    let id: Int
    let name: String
    @Binding var shareViewItem: ShareViewItem?

    @State private var pokemonDetails: PokemonViewModel?
    @State private var isFavorited: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading) {
                ListCardImage(
                    thumbnail: pokemonDetails?.thumbnail,
                    showFallbackImage: (pokemonDetails != nil && pokemonDetails?.thumbnail == nil)
                )
                .padding(.top, 16)
                .padding(.horizontal, 8)
                idBadge
            }
            .background(Color.cellBackground)
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)

            HStack {
                Text(name.capitalized)
                    .modifier(FontTheme.headline)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)

                menuButton
            }
            .padding(.leading)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
        )
        .onAppear { checkFavoriteStatus() }
        .task { await loadDetails() }
    }
}

// MARK: - Subviews
private extension ListCard {
    var idBadge: some View {
        Text(String(format: "%03d", id))
            .modifier(FontTheme.subHeadline)
            .padding(.vertical, 2)
            .padding(.horizontal, 6)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.tint)
            )
            .padding(8)
    }

    var menuButton: some View {
        Menu {
            if isFavorited {
                Button("Remove from favorite") {
                    try? favoritesRepository?.unfavorite(for: id)
                }
            } else {
                Button("Add to favorite") {
                    try? favoritesRepository?.favorite(for: id)
                }
            }
            Button("Share") { shareViewItem = ShareViewItem(pokemonId: id) }
        } label: {
            Image(systemName: "ellipsis")
                .foregroundStyle(Color.primaryText)
                .rotationEffect(.degrees(90))
                .frame(width: 42, height: 42)
        }
        .menuStyle(.borderlessButton)
    }
}

// MARK: - Data Loading
private extension ListCard {
    func loadDetails() async {
        guard let pokemonRepository else { return }
        do {
            self.pokemonDetails = try await pokemonRepository.loadDetail(for: name)
        } catch {
            print("Error loading detail:", error)
        }
    }

    func checkFavoriteStatus() {
        do {
            self.isFavorited = try favoritesRepository?.isFavorited(for: id) ?? false
        } catch let error {
            print(
                "Something went wrong fetch favorite status: \(error.localizedDescription)"
            )
        }
    }
}

#Preview {
    ListCard(id: 2, name: "Ivysaur", shareViewItem: .constant(nil))
        .frame(width: 163, height: 211)
}
