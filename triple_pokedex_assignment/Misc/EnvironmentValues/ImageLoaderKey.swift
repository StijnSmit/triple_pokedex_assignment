//
//  ImageLoaderKey.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import SwiftUI

private struct ImageLoaderKey: EnvironmentKey {
    static let defaultValue: ImageLoader = ImageLoader()
}

extension EnvironmentValues {
    var imageLoader: ImageLoader {
        get { self[ImageLoaderKey.self] }
        set { self[ImageLoaderKey.self] = newValue }
    }
}
