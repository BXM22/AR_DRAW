//
//  OpacitySlider.swift
//  AR_DRAW
//

import SwiftUI

struct OpacitySlider: View {
    @Binding var value: Double
    var isEnabled: Bool = true

    private let thumbWidth: CGFloat = 16
    private let thumbHeight: CGFloat = 28
    private let trackHeight: CGFloat = 2
    private let hitHeight: CGFloat = 44

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let travel = max(width - thumbWidth, 1)
            let x = CGFloat(value) * travel

            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Theme.sliderTrack)
                    .frame(height: trackHeight)
                    .frame(maxWidth: .infinity)

                Rectangle()
                    .fill(Theme.accent)
                    .frame(width: thumbWidth, height: thumbHeight)
                    .offset(x: x)
            }
            .frame(width: width, height: hitHeight)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        guard isEnabled else { return }
                        let raw = (gesture.location.x - thumbWidth / 2) / travel
                        value = min(max(Double(raw), 0), 1)
                    }
            )
        }
        .frame(height: hitHeight)
        .opacity(isEnabled ? 1 : 0.45)
        .allowsHitTesting(isEnabled)
        .accessibilityLabel("Overlay opacity")
        .accessibilityValue("\(Int(value * 100)) percent")
        .accessibilityAdjustableAction { direction in
            guard isEnabled else { return }
            switch direction {
            case .increment:
                value = min(value + 0.05, 1)
            case .decrement:
                value = max(value - 0.05, 0)
            @unknown default:
                break
            }
        }
    }
}
