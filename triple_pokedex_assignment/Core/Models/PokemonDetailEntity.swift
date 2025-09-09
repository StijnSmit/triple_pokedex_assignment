//
//  PokemonDetailEntity.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import Foundation
import SwiftData

@Model
final class PokemonDetailEntity {
    @Attribute(.unique) var id: Int
    var name: String
    var baseExperience: Int
    var height: Int
    var weight: Int
    var sprites: PokemonSpriteEntity
    var cries: PokemonCryEntity
    var abilities: [PokemonAbilityEntity]
    var stats: [PokemonStatEntity]
    var types: [PokemonTypeEntity]
    var speciesId: Int?
    var species: SpeciesEntity?

    init(
        id: Int,
        name: String,
        baseExperience: Int,
        height: Int,
        weight: Int,
        sprites: PokemonSpriteEntity,
        cries: PokemonCryEntity,
        abilities: [PokemonAbilityEntity],
        stats: [PokemonStatEntity],
        types: [PokemonTypeEntity],
        speciesId: Int?,
        species: SpeciesEntity?
    ) {
        self.id = id
        self.name = name
        self.baseExperience = baseExperience
        self.height = height
        self.weight = weight
        self.sprites = sprites
        self.cries = cries
        self.abilities = abilities
        self.stats = stats
        self.types = types
        self.speciesId = speciesId
        self.species = species
    }
}

@Model
final class PokemonSpriteEntity {
    var front: String?
    var back: String?
    var homeArtworkFront: String?
    var officialArtworkFront: String?

    init(
        front: String?,
        back: String?,
        homeArtworkFront: String?,
        officialArtworkFront: String?
    ) {
        self.front = front
        self.back = back
        self.homeArtworkFront = homeArtworkFront
        self.officialArtworkFront = officialArtworkFront
    }
}

@Model
final class PokemonCryEntity {
    var latest: String?
    var legacy: String?

    init(latest: String?, legacy: String?) {
        self.latest = latest
        self.legacy = legacy
    }
}


@Model
final class PokemonAbilityEntity {
    var isHidden: Bool
    var slot: Int
    var name: String

    init(isHidden: Bool, slot: Int, name: String) {
        self.isHidden = isHidden
        self.slot = slot
        self.name = name
    }
}

@Model
final class PokemonStatEntity {
    var baseStat: Int
    var name: String

    init(baseStat: Int, name: String) {
        self.baseStat = baseStat
        self.name = name
    }
}

@Model
final class PokemonTypeEntity {
    var name: String
    var slot: Int

    init(name: String, slot: Int) {
        self.name = name
        self.slot = slot
    }
}
