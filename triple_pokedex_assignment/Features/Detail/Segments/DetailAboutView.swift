//
//  DetailAboutView.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import SwiftUI

struct DetailAboutView: View {
    let pokemonDetail: PokemonViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            createRow(title: "Name", value: pokemonDetail.name)
            createRow(title: "ID", value: pokemonDetail.idString)
            createRow(title: "Base", value: pokemonDetail.baseExperience)
            createRow(title: "Weight", value: pokemonDetail.weight)
            createRow(title: "Height", value: pokemonDetail.height)
            createRow(title: "Types", value: pokemonDetail.typesString)
            createRow(title: "Abilities", value: pokemonDetail.abilities)
        }
        .frame(maxWidth: .infinity)
    }

    func createRow(title: String, value: String) -> some View {
        return HStack(alignment: .center, spacing: 16) {
            Text(title)
                .lineLimit(2)
                .modifier(FontTheme.secondaryText)
                .frame(width: 100, alignment: .leading)
            Text(value)
                .lineLimit(0)
                .modifier(FontTheme.tertiaryText)
                .opacity(0.65)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
