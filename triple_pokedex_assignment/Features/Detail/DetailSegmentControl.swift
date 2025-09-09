//
//  DetailSegmentControl.swift
//  triple_pokedex_assignment
//
//  Created by Stijn Smit on 07/09/2025.
//

import SwiftUI

struct DetailSegmentControl: View {
    @Environment(\.hapticFeedback) private var haptic: UIImpactFeedbackGenerator

    let segments: [String]
    @Binding var selectedIndex: Int
    @Namespace private var animationNamespace

    var body: some View {
        ZStack(alignment: .bottom) {
            Capsule()
                .fill(Color.sliderBackground)
                .frame(height: 4)

            HStack(spacing: 0) {
                ForEach(segments.indices, id: \.self) { index in
                    segmentButton(for: index)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }

    @ViewBuilder
    private func segmentButton(for index: Int) -> some View {
        let isSelected = selectedIndex == index

        Button {
            haptic.impactOccurred()
            withAnimation {
                selectedIndex = index
            }
        } label: {
            VStack(spacing: 4) {
                Text(segments[index])
                    .modifier(FontTheme.secondaryText)
                    .opacity(isSelected ? 1.0 : 0.65)

                Capsule()
                    .fill(isSelected ? Color.tint : Color.clear)
                    .frame(height: isSelected ? 4 : 2)
                    .if(isSelected) {
                        $0.matchedGeometryEffect(id: "Tab", in: animationNamespace)
                    }
            }
        }
    }
}
