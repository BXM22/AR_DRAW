//
//  OverlayImageView.swift
//  AR_DRAW
//

import SwiftUI

struct OverlayImageView: View {
    let image: Image
    let transform: OverlayTransform
    let opacity: Double

    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scaleEffect(transform.scale)
            .rotationEffect(transform.rotation)
            .offset(transform.offset)
            .opacity(opacity)
            .allowsHitTesting(false)
            .accessibilityLabel("Reference overlay")
            .accessibilityHidden(opacity < 0.02)
    }
}
