//
//  PokemonEntity.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import Foundation
import SwiftData

@Model
final class PokemonEntity {
    @Attribute(.unique) var id: Int
    var name: String
    var isFavorite: Bool = false

    init(id: Int,
         name: String,
         isFavorite: Bool = false
    ) {
        self.id = id
        self.name = name
        self.isFavorite = isFavorite
    }
}
