//
//  PokemonReponse.swift
//  PokedexAPI
//
//  Created by Stijn Smit on 07/09/2025.
//

public struct PokemonResponse: Decodable, Sendable {
    public let id: Int
    public let name: String
    public let baseExperience: Int
    public let height: Int
    public let weight: Int
    public let sprites: PokemonSprite
    public let cries: PokemonCry
    public let abilities: [PokemonAbility]
    public let stats: [PokemonStat]
    public let types: [PokemonType]
    public let speciesUrl: String

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case baseExperience = "base_experience"
        case height
        case weight
        case sprites
        case cries
        case abilities
        case stats
        case types
        case species
        case url
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        baseExperience = try container.decode(Int.self, forKey: .baseExperience)
        weight = try container.decode(Int.self, forKey: .weight)
        height = try container.decode(Int.self, forKey: .height)
        sprites = try container.decode(PokemonSprite.self, forKey: .sprites)
        cries = try container.decode(PokemonCry.self, forKey: .cries)
        abilities = try container.decode([PokemonAbility].self, forKey: .abilities)
        stats = try container.decode([PokemonStat].self, forKey: .stats)
        types = try container.decode([PokemonType].self, forKey: .types)
        let speciesContainer = try container.nestedContainer(
            keyedBy: CodingKeys.self,
            forKey: .species
        )
        speciesUrl = try speciesContainer.decode(String.self, forKey: .url)
    }
}

public struct PokemonSprite: Decodable, Sendable {
    public let front: String?
    public let back: String?
    public let homeArtworkFront: String?
    public let officialArtworkFront: String?

    private enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case backDefault = "back_default"
        case other
        case home
        case officialArtwork = "official-artwork"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        front = try container
            .decodeIfPresent(String.self, forKey: .frontDefault)
        back = try container
            .decodeIfPresent(String.self, forKey: .backDefault)

        // The other Container
        let otherContainer = try container.nestedContainer(
            keyedBy: CodingKeys.self,
            forKey: .other
        )

        // The home Container
        let homeContainer = try otherContainer.nestedContainer(
            keyedBy: CodingKeys.self,
            forKey: .home
        )
        homeArtworkFront = try homeContainer
            .decodeIfPresent(String.self, forKey: .frontDefault)

        // The official-artwork Container
        let officialContainer = try otherContainer.nestedContainer(
            keyedBy: CodingKeys.self,
            forKey: .officialArtwork
        )
        officialArtworkFront = try officialContainer
            .decodeIfPresent(String.self, forKey: .frontDefault)
    }
}

public struct PokemonCry: Decodable, Sendable {
    public let latest: String?
    public let legacy: String?
}

public struct PokemonAbility: Decodable, Sendable {
    public let isHidden: Bool
    public let slot: Int
    public let name: String

    private enum CodingKeys: String, CodingKey {
        case isHidden = "is_hidden"
        case slot
        case ability
        case name
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isHidden = try container.decode(Bool.self, forKey: .isHidden)
        slot = try container.decode(Int.self, forKey: .slot)
        let abilityContainer = try container.nestedContainer(
            keyedBy: CodingKeys.self,
            forKey: .ability
        )
        name = try abilityContainer.decode(String.self, forKey: .name)
    }
}

public struct PokemonStat: Decodable, Sendable {
    public let baseStat: Int
    public let name: String

    private enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
        case name
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        baseStat = try container.decode(Int.self, forKey: .baseStat)
        let statContainer = try container.nestedContainer(
            keyedBy: CodingKeys.self,
            forKey: .stat
        )
        name = try statContainer.decode(String.self, forKey: .name)
    }
}

public struct PokemonType: Decodable, Sendable {
    public let slot: Int
    public let name: String

    private enum CodingKeys: String, CodingKey {
        case slot
        case type
        case name
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        slot = try container.decode(Int.self, forKey: .slot)
        let typeContainer = try container.nestedContainer(
            keyedBy: CodingKeys.self,
            forKey: .type
        )
        name = try typeContainer.decode(String.self, forKey: .name)
    }
}
