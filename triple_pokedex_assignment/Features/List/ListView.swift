//
//  ListView.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//
import SwiftUI
import SwiftData

struct ListView: View {
    let viewType: ListViewType
    @Environment(\.hapticFeedback) private var haptic: UIImpactFeedbackGenerator

    @Query(
        filter: #Predicate<PokemonEntity> { $0.isFavorite == true },
        sort: \PokemonEntity.id
    )
    private var allPokemon: [PokemonEntity]

    @State private var path = NavigationPath()
    @State private var searchText = ""
    @State private var debouncedText = ""
    @State private var debounceTask: Task<Void, Never>? = nil
    @State private var tabBarVisibility: Visibility = .visible
    @State private var shareViewItem: ShareViewItem?

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible())
    ]

    init(viewType: ListViewType = .all) {
        _allPokemon = Query(
            filter: viewType == .favorites
                ? #Predicate<PokemonEntity> { $0.isFavorite == true }
                : nil,
            sort: \PokemonEntity.id
        )
        self.viewType = viewType
    }


    // MARK: - Computed Properties
    private var searchResults: [PokemonEntity] {
        guard !debouncedText.isEmpty else { return allPokemon }
        return allPokemon.filter {
            $0.name.lowercased().contains(debouncedText.lowercased())
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                pokemonGrid
                    .searchable(text: $searchText, prompt: "Search for Pokémon.")
                    .padding()
                    .toolbarBackground(.clear, for: .navigationBar)
                    .overlay(alignment: .center) {
                        if allPokemon.isEmpty {
                            Text("You have not favorited any Pokemon yet!")
                                .modifier(FontTheme.headline)
                        }
                    }
            }
            .onAppear { showTabBar() }
            .toolbar(tabBarVisibility, for: .tabBar)
            .background(Color.background)
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle(viewType.title)
            .onAppear { showTabBar() }
            .onChange(of: path) { oldValue, newValue in
                if newValue.isEmpty {
                    showTabBar()
                } else {
                    hideTabBar()
                }
            }
            .onChange(of: searchText) { oldValue, newValue in
                // Cancel any pending task
                debounceTask?.cancel()

                // Start a new task
                debounceTask = Task {
                    try? await Task.sleep(nanoseconds: 300_000_000) // 0.3s
                    if !Task.isCancelled {
                        debouncedText = newValue
                    }
                }
            }
            .sheet(item: $shareViewItem) { item in
                ShareView(pokemonId: item.pokemonId)
                    .presentationDetents([.medium])
            }
        }
    }
}

// MARK: - Subviews
private extension ListView {
    var pokemonGrid: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(searchResults, id: \.self) { pokemon in
                NavigationLink {
                    DetailView(pokemonId: pokemon.id)
                        .onAppear { hideTabBar() }
                } label: {
                    ListCard(
                        id: pokemon.id,
                        name: pokemon.name,
                        shareViewItem: $shareViewItem
                    )
                }
            }
        }
    }
}

// MARK: - Tab Bar Helpers
private extension ListView {
    func showTabBar() {
        withAnimation { tabBarVisibility = .visible }
    }

    func hideTabBar() {
        tabBarVisibility = .hidden
    }
}

#Preview {
    ListView()
}
