//
//  PermissionPlate.swift
//  AR_DRAW
//

import SwiftUI

struct PermissionPlate: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Camera access is off")
                .font(Theme.labelFont(size: 20, weight: .semibold))
                .foregroundStyle(Theme.paper)
                .fixedSize(horizontal: false, vertical: true)

            Text("Tracer needs the camera so you can line a reference photo up with your paper.")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Theme.onCameraSecondary)
                .fixedSize(horizontal: false, vertical: true)

            if let url = URL(string: UIApplication.openSettingsURLString) {
                Link(destination: url) {
                    Text("OPEN SETTINGS")
                        .font(Theme.labelFont(size: 13, weight: .semibold))
                        .tracking(Theme.labelTracking)
                        .foregroundStyle(Theme.paper)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Theme.accent)
                }
                .padding(.top, 4)
                .accessibilityLabel("Open Settings")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Theme.ink)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Theme.accent)
                .frame(height: Theme.plateTopRule)
        }
        .padding(.horizontal, Theme.sideInset)
    }
}

struct EmptyStatePlate: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Choose a reference")
                .font(Theme.labelFont(size: 20, weight: .semibold))
                .foregroundStyle(Theme.paper)
                .fixedSize(horizontal: false, vertical: true)

            Text("Then drag to position it, pinch to scale and rotate.")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Theme.onCameraSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Theme.ink)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Theme.accent)
                .frame(height: Theme.plateTopRule)
        }
        .padding(.horizontal, Theme.sideInset)
        .allowsHitTesting(false)
        .accessibilityElement(children: .combine)
    }
}
