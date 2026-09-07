//
//  OverlayGestures.swift
//  AR_DRAW
//

import SwiftUI

struct OverlayGestures: ViewModifier {
    @Binding var committed: OverlayTransform
    @Binding var live: OverlayTransform

    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle())
            .gesture(composedGesture)
    }

    private var composedGesture: some Gesture {
        SimultaneousGesture(
            DragGesture()
                .onChanged { value in
                    live.offset = value.translation
                }
                .onEnded { value in
                    committed.offset = CGSize(
                        width: committed.offset.width + value.translation.width,
                        height: committed.offset.height + value.translation.height
                    )
                    live.offset = .zero
                },
            SimultaneousGesture(
                MagnificationGesture()
                    .onChanged { value in
                        live.scale = value
                    }
                    .onEnded { value in
                        committed.scale = OverlayTransform.clampScale(committed.scale * value)
                        live.scale = 1
                    },
                RotationGesture()
                    .onChanged { value in
                        live.rotation = value
                    }
                    .onEnded { value in
                        committed.rotation += value
                        live.rotation = .zero
                    }
            )
        )
    }
}

extension View {
    func overlayGestures(
        committed: Binding<OverlayTransform>,
        live: Binding<OverlayTransform>
    ) -> some View {
        modifier(OverlayGestures(committed: committed, live: live))
    }
}
