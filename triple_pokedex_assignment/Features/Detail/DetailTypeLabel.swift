//
//  DetailTypeLabel.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import SwiftUI

struct DetailTypeLabel: View {
    let type: PokemonType

    var body: some View {
        Text(type.title)
            .modifier(FontTheme.text)
            .padding(EdgeInsets(top: 4, leading: 14, bottom: 4, trailing: 14))
            .background(
                Capsule()
                    .fill(type.color)
            )
    }
}
