//
//  BottomBar.swift
//  AR_DRAW
//

import PhotosUI
import SwiftUI

struct BottomBar: View {
    @Binding var pickedItem: PhotosPickerItem?
    @Binding var opacity: Double
    var controlsEnabled: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            PhotosPicker(
                selection: $pickedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                HStack(spacing: 10) {
                    Image(systemName: "photo.on.rectangle")
                        .font(.system(size: 15, weight: .semibold))
                    Text("PHOTOS")
                        .font(Theme.labelFont(size: 13, weight: .semibold))
                        .tracking(Theme.labelTracking)
                }
                .foregroundStyle(Theme.onCamera)
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                .padding(.horizontal, 14)
                .background(.ultraThinMaterial)
                .overlay {
                    Rectangle()
                        .strokeBorder(Theme.buttonBorder, lineWidth: 1)
                }
            }
            .disabled(!controlsEnabled)
            .opacity(controlsEnabled ? 1 : 0.45)
            .accessibilityLabel("Choose photo")

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("OPACITY")
                        .font(Theme.labelFont(size: 10.5, weight: .semibold))
                        .tracking(Theme.sectionTracking)
                        .foregroundStyle(Theme.onCameraTertiary)

                    Spacer()

                    Text("\(Int(opacity * 100))%")
                        .font(Theme.labelFont(size: 10.5, weight: .semibold))
                        .tracking(Theme.sectionTracking)
                        .foregroundStyle(Theme.onCamera)
                        .monospacedDigit()
                }

                OpacitySlider(value: $opacity, isEnabled: controlsEnabled)
            }
            .opacity(controlsEnabled ? 1 : 0.45)
        }
        .padding(.horizontal, Theme.sideInset)
        .padding(.top, 20)
        .padding(.bottom, Theme.bottomClearance)
        .frame(maxWidth: 560, alignment: .leading)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(
            LinearGradient(
                colors: [.clear, Theme.barScrimEnd],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .bottom)
            .allowsHitTesting(false)
        )
    }
}
