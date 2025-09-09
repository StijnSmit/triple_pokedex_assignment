//
//  Font.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import SwiftUI

struct FontTheme: ViewModifier {
    private let font: Font
    private let color: Color

    private init(font: Font, color: Color) {
        self.font = font
        self.color = color
    }

    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundStyle(color)
    }

    /// Cabinet Extra Bold 32
    static var largeTitle: FontTheme {
        return .init(font: .cabinetExtrabold32, color: Color.primaryText)
    }
    /// Cabinet Extra Bold 24
    static var title: FontTheme {
        return .init(font: .cabinetExtrabold24, color: Color.primaryText)
    }
    /// Cabinet Regular 24
    static var secondaryTitle: FontTheme {
        return .init(
            font: .cabinetRegular24,
            color: Color.primaryText.opacity(0.3)
        )
    }
    /// Rubik Medium 16
    static var headline: FontTheme {
        return .init(font: .rubikMedium16, color: Color.primaryText)
    }
    /// Rubik Medium 12
    static var subHeadline: FontTheme {
        return .init(font: .rubikMedium12, color: Color.secondaryText)
    }
    /// Rubik Semibold 16
    static var text: FontTheme {
        return .init(font: .rubikSemibold16, color: Color.primaryText)
    }
    /// Rubik Semibold 14
    static var secondaryText: FontTheme {
        return .init(font: .rubikSemibold14, color: Color.primaryText)
    }
    /// Rubik Regular 14
    static var tertiaryText: FontTheme {
        return .init(font: .rubikRegular14, color: Color.primaryText.opacity(0.65))
    }
}

extension Font {
    // MARK: - Cabinet Grotesk
    static var cabinetExtrabold32: Font {
        .custom("CabinetGrotesk-Extrabold", size: 32, relativeTo: .title)
    }

    static var cabinetExtrabold24: Font {
        .custom("CabinetGrotesk-Extrabold", size: 24, relativeTo: .title2)
    }

    static var cabinetRegular24: Font {
        .custom("CabinetGrotesk-Regular", size: 24, relativeTo: .title3)
    }

    // MARK: - Rubik
    static var rubikMedium16: Font {
        .custom("Rubik-Medium", size: 16, relativeTo: .body)
    }

    static var rubikMedium12: Font {
        .custom("Rubik-Medium", size: 12, relativeTo: .caption2)
    }

    static var rubikSemibold16: Font {
        .custom("Rubik-Semibold", size: 16, relativeTo: .body)
    }

    static var rubikSemibold14: Font {
        .custom("Rubik-Semibold", size: 14, relativeTo: .callout)
    }

    static var rubikRegular14: Font {
        .custom("Rubik-Regular", size: 14, relativeTo: .callout)
    }
}
