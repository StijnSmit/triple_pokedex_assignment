//
//  ShareView.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import SwiftUI

struct ShareViewItem: Identifiable {
    let pokemonId: Int

    var id: Int { pokemonId }
}

struct ShareView: UIViewControllerRepresentable {
    let items: [Any]
    let excludedActivityTypes: [UIActivity.ActivityType]?

    init?(pokemonId: Int, excludedActivityTypes: [UIActivity.ActivityType]? = nil) {
        guard let url = URLSharingService.pokemonURL(pokemonId: pokemonId) else {
            return nil
        }
        self.items = ["Check out this Pokemon!", url]
        self.excludedActivityTypes = excludedActivityTypes
    }

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        activityViewController.excludedActivityTypes = excludedActivityTypes
        return activityViewController
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
