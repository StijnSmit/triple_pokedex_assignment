//
//  ListViewType.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

enum ListViewType {
    case all
    case favorites

    var title: String {
        switch self {
            case .all:
                return "All Pokémon's"
            case .favorites:
                return "My favorites"
        }
    }
}
