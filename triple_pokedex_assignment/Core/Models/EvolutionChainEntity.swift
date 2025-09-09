//
//  EvolutionChainEntity.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import Foundation
import SwiftData

@Model
final class EvolutionChainEntity {
    @Attribute(.unique) var id: Int
    @Relationship(deleteRule: .cascade, inverse: \EvolutionChainLinkEntity.chain)
    var evolutions: [EvolutionChainLinkEntity]

    init(id: Int, evolutions: [EvolutionChainLinkEntity]) {
        self.id = id
        self.evolutions = evolutions
    }
}

@Model
final class EvolutionChainLinkEntity {
    @Attribute(.unique)
    var pokemonName: String
    var position: Int
    var speciesId: Int
    var chain: EvolutionChainEntity?

    init(
        pokemonName: String,
        position: Int,
        speciesId: Int,
        chain: EvolutionChainEntity? = nil
    ) {
        self.pokemonName = pokemonName
        self.position = position
        self.speciesId = speciesId
        self.chain = chain
    }
}
