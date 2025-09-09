//
//  EvolutionResponse.swift
//  PokedexAPI
//
//  Created by Stijn Smit on 07/09/2025.
//

public struct EvolutionResponse: Decodable, Sendable {
    public let id: Int
    public let chain: EvolutionChainLink
}

public struct EvolutionChainLink: Decodable, Sendable {
    public let pokemonName: String
    public let pokemonSpeciesUrl: String
    public let evolvesTo: [EvolutionChainLink]

    private enum CodingKeys: String, CodingKey {
        case species
        case name
        case evolvesTo = "evolves_to"
        case url
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let speciesContainer = try container
            .nestedContainer(keyedBy: CodingKeys.self, forKey: .species)
        pokemonName = try speciesContainer.decode(String.self, forKey: .name)
        pokemonSpeciesUrl = try speciesContainer.decode(String.self, forKey: .url)
        evolvesTo = try container
            .decode([EvolutionChainLink].self, forKey: .evolvesTo)
    }
}
