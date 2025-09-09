//
//  DetailView.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.favoritesRepository) private var favoritesRepository
    @Environment(\.pokemonRepository) private var pokemonRepository
    @Environment(\.imageLoader) private var imageLoader
    @Environment(\.audioPlayer) private var audioPlayer: AudioPlayer
    @Environment(\.hapticFeedback) private var haptic: UIImpactFeedbackGenerator

    let pokemonId: Int

    @State private var pokemonDetail: PokemonViewModel?
    @State private var evolutionChain: EvolutionChainEntity?
    @State private var selectedSegment: Int = 0

    @State private var image: Image?
    @State private var hasFadedIn = false
    @State private var isFallbackImage = false

    @State private var showShareSheet = false
    @State private var showPokemonNotFoundError = false
    @State private var isFavorited = false

    var body: some View {
        Group {
            if let pokemonDetail {
                content(for: pokemonDetail)
            } else {
                ProgressView()
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationBarBackButtonHidden(true)
        .background(Color.white)
        .onAppear { checkFavoriteStatus() }
        .task { await loadDetail() }
        .task(id: pokemonDetail) { await loadImage() }
        .task(id: pokemonDetail) { await loadEvolution() }
        .sheet(isPresented: $showShareSheet) {
            ShareView(pokemonId: pokemonId)
                .presentationDetents([.medium])
        }
        .alert(isPresented: $showPokemonNotFoundError) {
            Alert(
                title: Text("Pokemon not found"),
                message: Text("It looks like the pokemon you are looking for doesn't exist!"),
                dismissButton:.default(
                    Text("Close"),
                    action: { dismiss() }
                ),
            )
        }
    }
}

// MARK: - Content
private extension DetailView {
    func content(for vm: PokemonViewModel) -> some View {
        VStack {
            headerSection(vm)
            segmentSection(vm)
        }
        .toolbar { toolbarContent(vm) }
    }

    func headerSection(_ vm: PokemonViewModel) -> some View {
        VStack(spacing: 8) {
            HStack(alignment: .top) {
                Text(vm.name)
                    .lineLimit(3)
                    .modifier(FontTheme.largeTitle)
                Spacer()
                Text("#" + vm.idString)
                    .modifier(FontTheme.secondaryTitle)
            }

            HStack(alignment: .top) {
                ForEach(vm.types, id: \.title) { type in
                    DetailTypeLabel(type: type)
                }
                Spacer()
            }

            imageView
                .padding(.horizontal, 62)
        }
        .padding(.horizontal)
        .background(
            Rectangle()
                .fill(Color.background)
                .ignoresSafeArea(edges: .top)
                .padding(.bottom, 40)
        )
    }

    func segmentSection(_ vm: PokemonViewModel) -> some View {
        VStack(spacing: 16) {
            DetailSegmentControl(
                segments: ["About", "Stats", "Evolution"],
                selectedIndex: $selectedSegment
            )
            .padding(.horizontal)

            TabView(selection: $selectedSegment) {
                ScrollView {
                    DetailAboutView(pokemonDetail: vm)
                        .padding(.horizontal)
                }
                .tag(0)

                ScrollView {
                    DetailStatsView(pokemonDetail: vm)
                        .padding(.horizontal)
                }
                .tag(1)

                ScrollView {
                    if let evolutionChain {
                        DetailEvolutionView(evolutionChain: evolutionChain)
                            .padding(.horizontal)
                    } else {
                        ProgressView()
                    }
                }
                .tag(2)
            }
            .frame(minHeight: 100)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }

    var imageView: some View {
        ZStack {
            Color.clear
            image?
                .resizable()
                .scaledToFit()
                .frame(maxWidth: isFallbackImage ? 80 : .infinity,
                       maxHeight: isFallbackImage ? 80 : .infinity)
                .if(!hasFadedIn) { $0.fadeIn(when: image) }
                .onChange(of: self.image) { _, newImage in
                    guard newImage != nil, !hasFadedIn else { return }
                    hasFadedIn = true
                }
                .foregroundStyle(Color.tint)
            if image == nil {
                ProgressView() }
            }
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
    }

    @ToolbarContentBuilder
    func toolbarContent(_ vm: PokemonViewModel) -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .padding(.trailing)
            }
            .foregroundColor(.primaryText)
        }

        ToolbarItemGroup(placement: .topBarTrailing) {
            if vm.cry != nil {
                Button(action: playPokemonSound) {
                    Image(systemName: "volume.3")
                }
                .foregroundColor(.primaryText)
            }

            Button(action: sharePokemon) {
                Image(systemName: "square.and.arrow.up")
            }
            .foregroundColor(.primaryText)

            Button(action: favoritePokemon) {
                ZStack {
                    likeImage(Image(systemName: "suit.heart.fill"), show: isFavorited)
                    likeImage(Image(systemName: "suit.heart"), show: !isFavorited)
                }
            }
            .foregroundColor(.primaryText)
        }
    }

    func likeImage(_ image: Image, show: Bool) -> some View {
        image
            .foregroundStyle(isFavorited ? .red : .black)
            .scaleEffect(show ? 1 : 0)
            .opacity(show ? 1 : 0)
            .animation(.interpolatingSpring(stiffness: 170, damping: 15), value: show)
    }
}

// MARK: - Data Loading
private extension DetailView {
    func loadDetail() async {
        guard let pokemonRepository else { return }
        do {
            self.pokemonDetail = try await pokemonRepository.loadDetail(for: pokemonId)
        } catch PokemonRepositoryError.pokemonNotFound {
            showPokemonNotFoundError = true
        } catch let error {
            print("Error loading detail:", error)
        }
    }

    func loadEvolution() async {
        guard let pokemonDetail, let pokemonRepository, evolutionChain == nil else {
            return
        }
        do {
            let evolution = try await pokemonRepository.loadEvolution(
                for: pokemonId
            )
            self.evolutionChain = evolution
        } catch let error {
            print("Error loading evolutionChain: ", error)
        }
    }

    func loadImage() async {
        guard let _ = pokemonDetail else { return }

        if let imageUrlString = pokemonDetail?.image,
           let uiImage = await imageLoader.image(from: imageUrlString) {
            isFallbackImage = false
            image = Image(uiImage: uiImage)
        } else {
            isFallbackImage = true
            image = Image("pokeball.fill")
        }
    }

    func checkFavoriteStatus() {
        do {
            self.isFavorited = try favoritesRepository?
                .isFavorited(for: pokemonId) ?? false
        } catch let error {
            print(
                "Something went wrong fetch favorite status: \(error.localizedDescription)"
            )
        }
    }
}

// MARK: - Actions
private extension DetailView {
    func playPokemonSound() {
        guard let urlString = pokemonDetail?.cry,
              let url = URL(string: urlString) else { return }
        audioPlayer.play(url)
        haptic.impactOccurred()
    }

    func sharePokemon() {
        showShareSheet = true
        haptic.impactOccurred()
    }

    func favoritePokemon() {
        guard let favoritesRepository else {
            return
        }
        do {
            if isFavorited {
                try favoritesRepository.unfavorite(for: pokemonId)
                self.isFavorited = false
            } else {
                try favoritesRepository.favorite(for: pokemonId)
                self.isFavorited = true
            }
            haptic.impactOccurred()
        } catch let error {
            print(
                "Something went wrong fetch favorite status: \(error.localizedDescription)"
            )
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(pokemonId: 1)
    }
}
