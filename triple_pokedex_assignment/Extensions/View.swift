//
//  View.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, modify: (Self) -> Content) -> some View {
        if condition {
            modify(self)
        } else {
            self
        }
    }
}
