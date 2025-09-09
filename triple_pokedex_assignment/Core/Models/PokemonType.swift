//
//  PokemonType.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import SwiftUI

enum PokemonType: Equatable {
    case normal, fire, water, electric, grass, ice
    case fighting, poison, ground, flying, psychic
    case bug, rock, ghost, dragon, dark, steel, fairy
    case unknown(title: String)

    init(from string: String) {
        switch string.lowercased() {
        case "normal":   self = .normal
        case "fire":     self = .fire
        case "water":    self = .water
        case "electric": self = .electric
        case "grass":    self = .grass
        case "ice":      self = .ice
        case "fighting": self = .fighting
        case "poison":   self = .poison
        case "ground":   self = .ground
        case "flying":   self = .flying
        case "psychic":  self = .psychic
        case "bug":      self = .bug
        case "rock":     self = .rock
        case "ghost":    self = .ghost
        case "dragon":   self = .dragon
        case "dark":     self = .dark
        case "steel":    self = .steel
        case "fairy":    self = .fairy
        default:         self = .unknown(title: string)
        }
    }

    var title: String {
        switch self {
        case .normal:   return "Normal"
        case .fire:     return "Fire"
        case .water:    return "Water"
        case .electric: return "Electric"
        case .grass:    return "Grass"
        case .ice:      return "Ice"
        case .fighting: return "Fighting"
        case .poison:   return "Poison"
        case .ground:   return "Ground"
        case .flying:   return "Flying"
        case .psychic:  return "Psychic"
        case .bug:      return "Bug"
        case .rock:     return "Rock"
        case .ghost:    return "Ghost"
        case .dragon:   return "Dragon"
        case .dark:     return "Dark"
        case .steel:    return "Steel"
        case .fairy:    return "Fairy"
        case .unknown(let title):  return title
        }
    }

    var color: Color {
        switch self {
        case .normal:   return Color.PokemonTypes.normal
        case .fire:     return Color.PokemonTypes.fire
        case .water:    return Color.PokemonTypes.water
        case .electric: return Color.PokemonTypes.electric
        case .grass:    return Color.PokemonTypes.grass
        case .ice:      return Color.PokemonTypes.ice
        case .fighting: return Color.PokemonTypes.fighting
        case .poison:   return Color.PokemonTypes.poison
        case .ground:   return Color.PokemonTypes.ground
        case .flying:   return Color.PokemonTypes.flying
        case .psychic:  return Color.PokemonTypes.psychic
        case .bug:      return Color.PokemonTypes.bug
        case .rock:     return Color.PokemonTypes.rock
        case .ghost:    return Color.PokemonTypes.ghost
        case .dragon:   return Color.PokemonTypes.dragon
        case .dark:     return Color.PokemonTypes.dark
        case .steel:    return Color.PokemonTypes.steel
        case .fairy:    return Color.PokemonTypes.fairy
        case .unknown:  return Color.PokemonTypes.normal // fallback
        }
    }
}
