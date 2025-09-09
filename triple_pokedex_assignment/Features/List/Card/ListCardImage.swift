//
//  ListCardImage.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import SwiftUI

struct ListCardImage: View {
    @Environment(\.imageLoader) private var imageLoader
    let thumbnail: String?
    let showFallbackImage: Bool

    @State private var image: Image?
    @State private var hasFadedIn = false

    var body: some View {
        ZStack {
            Color(Color.cellBackground)
            if let image {
                imageView(image)
            } else {
                ProgressView()
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .frame(maxWidth: .infinity)
        .task(id: thumbnail, { await loadImage() })
        .task(id: showFallbackImage, { setFallbackImage() })
    }
}

private extension ListCardImage {
    @ViewBuilder
    func imageView(_ image: Image) -> some View {
        image
            .resizable()
            .interpolation(.none)
            .if(!hasFadedIn) { $0.fadeIn(when: image) }
            .frame(maxWidth: showFallbackImage ? 80 : .infinity,
                   maxHeight: showFallbackImage ? 80 : .infinity)
            .onChange(of: self.image) { _, newImage in
                guard newImage != nil, !hasFadedIn else { return }
                hasFadedIn = true
            }
    }

    func setFallbackImage() {
        if showFallbackImage {
            self.image = Image("pokeball.fill")
        }
    }

    func loadImage() async {
        if showFallbackImage {
            self.image = Image("pokeball.fill")
        }
        if let thumbnail, let uiImage = await imageLoader.image(from: thumbnail) {
            self.image = Image(uiImage: uiImage)
        }
    }
}
