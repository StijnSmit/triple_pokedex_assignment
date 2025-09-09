//
//  HapticFeedbackKey.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 09/09/2025.
//

import SwiftUI
import UIKit

private struct HapticFeedbackKey: EnvironmentKey {
    static let defaultValue: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
}

extension EnvironmentValues {
    var hapticFeedback: UIImpactFeedbackGenerator {
        get { self[HapticFeedbackKey.self] }
        set { self[HapticFeedbackKey.self] = newValue }
    }
}
