//
//  SpeciesResponse.swift
//  PokedexAPI
//
//  Created by Stijn Smit on 07/09/2025.
//

public struct SpeciesResponse: Decodable, Sendable {
    public let id: Int
    public let evolutionUrl: String

    private enum CodingKeys: String, CodingKey {
        case id
        case evolutionChain = "evolution_chain"
        case url
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        let evolutionContainer = try container
            .nestedContainer(keyedBy: CodingKeys.self, forKey: .evolutionChain)
        evolutionUrl = try evolutionContainer.decode(String.self, forKey: .url)
    }
}
