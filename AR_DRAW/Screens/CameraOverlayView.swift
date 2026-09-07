//
//  CameraOverlayView.swift
//  AR_DRAW
//

import PhotosUI
import SwiftUI

struct CameraOverlayView: View {
    @State private var camera = CameraSession()
    @State private var pickedItem: PhotosPickerItem?
    @State private var overlayImage: Image?
    @State private var committed = OverlayTransform.initial
    @State private var live = OverlayTransform.liveIdentity
    @State private var opacity: Double = 0.4
    @State private var isMenuOpen = true
    @Environment(\.scenePhase) private var scenePhase

    private var renderedTransform: OverlayTransform {
        committed.combining(live: live)
    }

    private var cameraDenied: Bool {
        switch camera.authorizationStatus {
        case .denied, .restricted: true
        default: false
        }
    }

    private var controlsEnabled: Bool { !cameraDenied }
    private var hasOverlay: Bool { overlayImage != nil }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                cameraLayer

                if camera.isUsable {
                    GridOverlay()
                        .ignoresSafeArea()
                }

                if let overlayImage {
                    OverlayImageView(
                        image: overlayImage,
                        transform: renderedTransform,
                        opacity: opacity
                    )
                    .ignoresSafeArea()
                }

                // Gestures only when menu is closed so adjusting controls doesn't move the photo.
                if hasOverlay, camera.isUsable, !isMenuOpen {
                    Color.clear
                        .ignoresSafeArea()
                        .overlayGestures(committed: $committed, live: $live)
                }

                if !hasOverlay, !cameraDenied {
                    emptyState(in: geo.size)
                }

                if cameraDenied {
                    VStack {
                        Spacer(minLength: 0)
                        PermissionPlate()
                        Spacer(minLength: 0)
                    }
                }

                ControlsMenu(
                    isOpen: $isMenuOpen,
                    pickedItem: $pickedItem,
                    opacity: $opacity,
                    controlsEnabled: controlsEnabled,
                    hasOverlay: hasOverlay
                )
            }
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
        .statusBarHidden(true)
        .task {
            await camera.requestAccessIfNeeded()
        }
        .onChange(of: scenePhase) { _, phase in
            switch phase {
            case .active:
                camera.start()
            case .background:
                camera.stop()
            default:
                break
            }
        }
        .onChange(of: pickedItem) { _, newItem in
            Task { await handlePickedItem(newItem) }
        }
    }

    @ViewBuilder
    private var cameraLayer: some View {
        switch camera.authorizationStatus {
        case .authorized:
            CameraPreview(session: camera.captureSession)
                .ignoresSafeArea()
        case .notDetermined, .denied, .restricted:
            Theme.ink.ignoresSafeArea()
        }
    }

    private func emptyState(in size: CGSize) -> some View {
        EmptyStatePlate()
            .position(
                x: size.width / 2,
                y: size.height * Theme.emptyStateVerticalBias
            )
    }

    private func handlePickedItem(_ item: PhotosPickerItem?) async {
        guard let item else { return }
        guard let uiImage = await ImageLoader.loadDownsampledImage(from: item) else { return }
        overlayImage = Image(uiImage: uiImage)
        committed = .initial
        live = .liveIdentity
        withAnimation(.snappy(duration: 0.22)) {
            isMenuOpen = false
        }
    }
}

#Preview {
    CameraOverlayView()
}
