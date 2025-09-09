//
//  SpeciesEntity.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import Foundation
import SwiftData

@Model
final class SpeciesEntity {
    @Attribute(.unique) var id: Int
    var evolutionUrlString: String
    var evolutionId: Int?

    init(id: Int, evolutionUrlString: String) {
        self.id = id
        self.evolutionUrlString = evolutionUrlString
        self.evolutionId = evolutionUrlString
            .split(separator: "/").last
            .flatMap { Int($0) }
    }
}
