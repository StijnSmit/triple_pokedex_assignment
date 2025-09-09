//
//  DetailEvolutionView.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import SwiftUI

struct DetailEvolutionView: View {
    let evolutionChain: EvolutionChainEntity

    var body: some View {
        Group {
            if evolutionChain.evolutions.count <= 1 {
                Text("This pokemon has no evolutions")
                    .modifier(FontTheme.headline)
                    .padding(.vertical)
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(
                        Array(
                            evolutionChain.evolutions
                                .sorted(by: { $0.position < $1.position })
                                .enumerated()
                        ),
                        id: \.element
                    ) { (index, evolution) in
                        DetailEvolutionListCard(
                            name: evolution.pokemonName
                        )
                        if index != evolutionChain.evolutions.count - 1 {
                            dottedLine
                                .offset(x: 40)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
    }

    let lineHeight: CGFloat = 20.0
    var dottedLine: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(width: 1, height: lineHeight)
            .overlay(
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: lineHeight))
                }
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                    .foregroundColor(Color.primaryText)
                    .opacity(0.3)
            )
    }
}
