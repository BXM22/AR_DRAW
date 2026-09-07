//
//  Theme.swift
//  AR_DRAW
//

import SwiftUI

enum Theme {
    static let accent = Color(red: 0xEC / 255, green: 0x30 / 255, blue: 0x13 / 255)
    static let ink = Color(red: 0x20 / 255, green: 0x1E / 255, blue: 0x1D / 255)
    static let paper = Color(red: 0xF3 / 255, green: 0xF2 / 255, blue: 0xF2 / 255)

    static let onCamera = Color.white
    static let onCameraSecondary = Color.white.opacity(0.78)
    static let onCameraTertiary = Color.white.opacity(0.62)

    static let gridLine = Color.white.opacity(0.13)
    static let barScrimEnd = Color.black.opacity(0.72)
    static let buttonBorder = Color.white.opacity(0.45)
    static let sliderTrack = Color.white.opacity(0.35)

    static let sideInset: CGFloat = 24
    static let bottomClearance: CGFloat = 34
    static let plateTopRule: CGFloat = 2
    static let emptyStateVerticalBias: CGFloat = 0.47

    static let labelTracking: CGFloat = 0.78 // ~0.06em at 13pt
    static let sectionTracking: CGFloat = 0.63 // ~0.06em at 10.5pt

    static func labelFont(size: CGFloat, weight: Font.Weight = .semibold) -> Font {
        .system(size: size, weight: weight).width(.condensed)
    }
}
