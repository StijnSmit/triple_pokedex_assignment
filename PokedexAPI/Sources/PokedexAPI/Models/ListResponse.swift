//
//  ListResponse.swift
//  PokedexAPI
//
//  Created by Stijn Smit on 07/09/2025.
//

public struct PokemonListResponse: Codable, Sendable {
    public let count: Int
    public let next: String?
    public let previous: String?
    public let results: [PokemonListItem]
}

public struct PokemonListItem: Codable, Sendable {
    public let name: String
    public let url: String

    public var id: Int? {
        Int(url.split(separator: "/").last ?? "")
    }
}

