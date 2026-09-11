//
//  BottomBar.swift
//  AR_DRAW
//

import PhotosUI
import SwiftUI

/// Collapsible corner menu — keeps Photos + opacity off the canvas while tracing.
struct ControlsMenu: View {
    @Binding var isOpen: Bool
    @Binding var pickedItem: PhotosPickerItem?
    @Binding var showFileImporter: Bool
    @Binding var opacity: Double
    var controlsEnabled: Bool
    var hasOverlay: Bool

    private let buttonSize: CGFloat = 48

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if isOpen {
                Color.black.opacity(0.28)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.snappy(duration: 0.22)) {
                            isOpen = false
                        }
                    }
                    .accessibilityLabel("Dismiss menu")
            }

            VStack(alignment: .trailing, spacing: 10) {
                if isOpen {
                    menuPanel
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                menuToggle
            }
            .padding(.trailing, Theme.sideInset)
            .padding(.bottom, Theme.bottomClearance)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .animation(.snappy(duration: 0.22), value: isOpen)
    }

    private var menuToggle: some View {
        Button {
            withAnimation(.snappy(duration: 0.22)) {
                isOpen.toggle()
            }
        } label: {
            Image(systemName: isOpen ? "xmark" : "slider.horizontal.3")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Theme.onCamera)
                .frame(width: buttonSize, height: buttonSize)
                .background(.ultraThinMaterial)
                .overlay {
                    Rectangle()
                        .strokeBorder(isOpen ? Theme.accent : Theme.buttonBorder, lineWidth: 1)
                }
        }
        .accessibilityLabel(isOpen ? "Close controls" : "Open controls")
        .accessibilityHint("Photos, Files, and opacity")
    }

    private var menuPanel: some View {
        VStack(alignment: .leading, spacing: 16) {
            PhotosPicker(
                selection: $pickedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                sourceRow(
                    systemImage: "photo.on.rectangle",
                    title: hasOverlay ? "CHANGE PHOTO" : "PHOTOS"
                )
            }
            .disabled(!controlsEnabled)
            .opacity(controlsEnabled ? 1 : 0.45)
            .accessibilityLabel(hasOverlay ? "Change photo" : "Choose photo")

            Button {
                showFileImporter = true
            } label: {
                sourceRow(
                    systemImage: "folder",
                    title: hasOverlay ? "CHANGE FROM FILES" : "FILES"
                )
            }
            .disabled(!controlsEnabled)
            .opacity(controlsEnabled ? 1 : 0.45)
            .accessibilityLabel(hasOverlay ? "Change photo from Files" : "Choose photo from Files")

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

                OpacitySlider(value: $opacity, isEnabled: controlsEnabled && hasOverlay)
            }
            .opacity(controlsEnabled ? 1 : 0.45)
        }
        .padding(16)
        .frame(width: 280)
        .background(.ultraThinMaterial)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Theme.accent)
                .frame(height: Theme.plateTopRule)
        }
        .overlay {
            Rectangle()
                .strokeBorder(Theme.buttonBorder, lineWidth: 1)
        }
    }

    private func sourceRow(systemImage: String, title: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .font(.system(size: 15, weight: .semibold))
            Text(title)
                .font(Theme.labelFont(size: 13, weight: .semibold))
                .tracking(Theme.labelTracking)
        }
        .foregroundStyle(Theme.onCamera)
        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
        .padding(.horizontal, 14)
        .background(Theme.ink.opacity(0.55))
        .overlay {
            Rectangle()
                .strokeBorder(Theme.buttonBorder, lineWidth: 1)
        }
    }
}
