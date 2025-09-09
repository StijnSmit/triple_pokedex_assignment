//
//  FavoritesRepositoryKey.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import SwiftUI

private struct FavoritesRepositoryKey: EnvironmentKey {
    static let defaultValue: FavoritesRepository? = nil
}

extension EnvironmentValues {
    var favoritesRepository: FavoritesRepository? {
        get { self[FavoritesRepositoryKey.self] }
        set { self[FavoritesRepositoryKey.self] = newValue }
    }
}
