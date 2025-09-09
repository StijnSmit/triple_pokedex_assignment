//
//  URLSharingService.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import Foundation

class URLSharingService {
    private static let urlScheme = "triplepokedex"

    // Generate shareable URL for a Pokemon
    static func pokemonURL(pokemonId: Int) -> URL? {
        var components = URLComponents()
        components.scheme = urlScheme
        components.host = "pokemon"
        components.path = "/\(pokemonId)"
        return components.url
    }
}
