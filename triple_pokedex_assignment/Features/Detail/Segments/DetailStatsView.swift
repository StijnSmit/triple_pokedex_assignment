//
//  DetailStatsView.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import SwiftUI

struct DetailStatsView: View {
    let pokemonDetail: PokemonViewModel

    var body: some View {
        VStack(spacing: 24) {
            ForEach(pokemonDetail.stats, id: \.title) { stat in
                StatRow(name: stat.title, value: stat.value)
            }
        }
    }
}

private struct StatRow: View {
    let name: String
    let value: Int
    let maxValue: Int = 100

    @State private var progress: CGFloat = 0

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(name)
                    .modifier(FontTheme.secondaryText)
                Spacer()
                Text(String(value))
                    .modifier(FontTheme.tertiaryText)
                    .opacity(0.65)
            }

            GeometryReader { reader in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.sliderBackground)
                        .frame(height: 4)

                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.tint)
                        .frame(
                            width: progress * reader.size.width,
                            height: 4
                        )
                }
            }
            .frame(height: 4)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                progress = min(CGFloat(value) / CGFloat(maxValue), 1.0)
            }
        }
    }
}
