//
//  ImageLoader.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import UIKit

actor ImageLoader {
    private let session: URLSession

    private let cache: URLCache

    init(session: URLSession = .shared, cache: URLCache = .shared) {
        self.session = session
        self.cache = cache
    }
}

// MARK: - Public functions
extension ImageLoader {
    func image(from urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        return await image(from: url)
    }

    func image(from url: URL) async -> UIImage? {
        let request = URLRequest(url: url)

        // Return cached image if available
        if let cachedResponse = cache.cachedResponse(for: request),
           let image = UIImage(data: cachedResponse.data) {
            return image
        }

        do {
            let (data, response) = try await session.data(for: request)
            cache.cache(response: response, withData: data, for: request)
            return UIImage(data: data)
        } catch let error {
            print("Error while downloading image: \(error)")
            return nil
        }

    }
}

// MARK: - Cache helper function
private extension URLCache {
    func cache(response: URLResponse, withData data: Data, for request: URLRequest) {
        guard let httpResponse = response as? HTTPURLResponse,
              200 ..< 300 ~= httpResponse.statusCode else {
            return
        }
        let cached = CachedURLResponse(response: response, data: data)
        storeCachedResponse(cached, for: request)
    }
}
