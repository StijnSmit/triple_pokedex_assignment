//
//  Endpoint.swift
//  PokedexAPI
//
//  Created by Stijn Smit on 08/09/2025.
//

import Foundation


struct Tssss {
    let id: Int
}
internal enum Endpoint {
    static let baseURL = URL(string: "https://pokeapi.co/api/v2")!

    case list(offset: Int, limit: Int)
    case details(Int)
    case evolutions(Int)
    case species(Int)

    private var path: String {
        switch self {
        case .list:
            return "/pokemon"
        case .details(let id):
            return "/pokemon/\(id)"
        case .evolutions(let id):
            return "/evolution-chain/\(id)"
        case .species(let id):
            return "/pokemon-species/\(id)"
        }
    }

    private var queryItems: [URLQueryItem]? {
        switch self {
        case .list(let offset, let limit):
            return [
                URLQueryItem(name: "offset", value: String(offset)),
                URLQueryItem(name: "limit",  value: String(limit))
            ]
        default:
            return nil
        }
    }

    var url: URL {
        var comps = URLComponents(url: Self.baseURL, resolvingAgainstBaseURL: false)!
        comps.path = Self.baseURL.path + path
        comps.queryItems = queryItems
        return comps.url!
    }
}
