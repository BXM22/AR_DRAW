//
//  OverlayTransform.swift
//  AR_DRAW
//

import SwiftUI

struct OverlayTransform: Equatable {
    var offset: CGSize = .init(width: 0, height: -20)
    var scale: CGFloat = 1
    var rotation: Angle = .zero

    static let initial = OverlayTransform()
    static let liveIdentity = OverlayTransform(offset: .zero, scale: 1, rotation: .zero)

    static let minScale: CGFloat = 0.15
    static let maxScale: CGFloat = 6.0

    /// Combines committed state with in-flight gesture deltas.
    func combining(live: OverlayTransform) -> OverlayTransform {
        OverlayTransform(
            offset: CGSize(
                width: offset.width + live.offset.width,
                height: offset.height + live.offset.height
            ),
            scale: scale * live.scale,
            rotation: rotation + live.rotation
        )
    }

    func clampedScale() -> OverlayTransform {
        var copy = self
        copy.scale = min(max(scale, Self.minScale), Self.maxScale)
        return copy
    }

    static func clampScale(_ value: CGFloat) -> CGFloat {
        min(max(value, minScale), maxScale)
    }
}
