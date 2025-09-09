//
//  PokemonStat.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import Foundation

struct PokemonStat: Sendable, Equatable {
    private let name: String
    let value: Int

    init(name: String, value: Int) {
        self.name = name
        self.value = value
    }

    var title: String {
        switch name {
            case "hp":
                return "HP"
            case "special-attack":
                return "Special Attack"
            case "special-defense":
                return "Special Defense"
            default:
                return name.capitalized
        }
    }
}
