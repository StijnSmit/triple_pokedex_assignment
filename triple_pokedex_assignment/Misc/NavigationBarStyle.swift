//
//  NavigationBarStyle.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import SwiftUI

func applyNavigationBarStyling() {
    let coloredAppearance = UINavigationBarAppearance()
    coloredAppearance.configureWithOpaqueBackground()
    coloredAppearance.backgroundColor = UIColor(Color.background)
    coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor(.black)]
    coloredAppearance.largeTitleTextAttributes = [ .foregroundColor: UIColor(.black),
                                                   .font: UIFont.systemFont(ofSize: 18) ]

    coloredAppearance.shadowColor = .clear
    coloredAppearance.shadowImage = UIImage()

    UINavigationBar.appearance().standardAppearance = coloredAppearance
    UINavigationBar.appearance().compactAppearance = coloredAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
}

