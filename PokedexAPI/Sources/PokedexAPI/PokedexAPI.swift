//
//  PokedexAPI.swift
//  PokedexAPI
//
//  Created by Stijn Smit on 07/09/2025.
//

import Foundation

public struct PokedexAPI {
    private let session: URLSession
    private let decoder: JSONDecoder

    public init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }

    // MARK: - Generic Request

    private func request<T: Decodable>(_ url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try decoder.decode(T.self, from: data)
    }

    // MARK: - Public Fetch Methods

    public func fetchList(offset: Int = 0, limit: Int = 20) async throws -> PokemonListResponse {
        try await request(Endpoint.list(offset: offset, limit: limit).url)
    }

    public func fetchPokemon(id: Int) async throws -> PokemonResponse {
        try await request(Endpoint.details(id).url)
    }

    public func fetchEvolution(id: Int) async throws -> EvolutionResponse {
        try await request(Endpoint.evolutions(id).url)
    }

    public func fetchEvolution(urlString: String) async throws -> EvolutionResponse {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return try await request(url)
    }

    public func fetchSpecies(id: Int) async throws -> SpeciesResponse {
        try await request(Endpoint.species(id).url)
    }
}
