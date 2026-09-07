//
//  CameraPreview.swift
//  AR_DRAW
//

import AVFoundation
import SwiftUI
import UIKit

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {
        if uiView.videoPreviewLayer.session !== session {
            uiView.videoPreviewLayer.session = session
        }
    }

    final class PreviewView: UIView {
        override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }

        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            layer as! AVCaptureVideoPreviewLayer
        }

        override func didMoveToWindow() {
            super.didMoveToWindow()
            syncRotation()
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            syncRotation()
        }

        private func syncRotation() {
            guard let connection = videoPreviewLayer.connection else { return }
            let orientation = window?.windowScene?.interfaceOrientation ?? .portrait
            let angle: CGFloat
            switch orientation {
            case .portrait: angle = 90
            case .portraitUpsideDown: angle = 270
            case .landscapeRight: angle = 180
            case .landscapeLeft: angle = 0
            default: angle = 90
            }
            guard connection.isVideoRotationAngleSupported(angle),
                  connection.videoRotationAngle != angle
            else { return }
            connection.videoRotationAngle = angle
        }
    }
}
