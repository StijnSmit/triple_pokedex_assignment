//
//  PokedexAPI+Errors.swift
//  PokedexAPI
//
//  Created by Stijn Smit on 08/09/2025.
//

import Foundation

enum PokedexAPIError: Error, LocalizedError {
    case badServerResponse
    case requestTimedOut
    case noInternet
    case decodingFailed(underlying: Error)
    case invalidURL
    case pokemonNotFound
    case unknown(underlying: Error)

    var errorDescription: String? {
        switch self {
        case .badServerResponse:
            return "The server returned an invalid response."
        case .requestTimedOut:
            return "The request took too long to complete."
        case .noInternet:
            return "You appear to be offline. Please check your internet connection."
        case .decodingFailed:
            return "Failed to decode the server response."
        case .invalidURL:
            return "The requested URL was invalid."
        case .pokemonNotFound:
            return "The requested Pokémon could not be found."
        case .unknown:
            return "An unexpected error occurred."
        }
    }
}
