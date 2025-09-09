//
//  FadeInViewModifier.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import SwiftUI

// MARK: - Fade in modifier
struct FadeInViewModifier<Value: Equatable>: ViewModifier {
    let value: Value
    let duration: Double

    @State private var isVisible = false

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .onAppear {
                withAnimation(.easeInOut(duration: duration)) {
                    isVisible = true
                }
            }
            .onChange(of: value) { oldValue, newValue in
                guard newValue != oldValue else { return }
                isVisible = false
                withAnimation(.easeInOut(duration: duration)) {
                    isVisible = true
                }
            }
    }
}

extension View {
    func fadeIn<Value: Equatable>(when value: Value, duration: Double = 0.4) -> some View {
        modifier(FadeInViewModifier(value: value, duration: duration))
    }
}
