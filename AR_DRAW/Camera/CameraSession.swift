//
//  CameraSession.swift
//  AR_DRAW
//

import AVFoundation
import Foundation

enum CameraAuthorization {
    case authorized
    case denied
    case notDetermined
    case restricted
}

@Observable
final class CameraSession {
    private(set) var authorizationStatus: CameraAuthorization

    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "com.ardraw.camera.session", qos: .userInitiated)
    private var isConfigured = false

    var captureSession: AVCaptureSession { session }
    var isUsable: Bool { authorizationStatus == .authorized }

    init() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            authorizationStatus = .authorized
        case .denied:
            authorizationStatus = .denied
        case .restricted:
            authorizationStatus = .restricted
        case .notDetermined:
            authorizationStatus = .notDetermined
        @unknown default:
            authorizationStatus = .denied
        }

        // Warm the session immediately when already allowed — don't wait for SwiftUI .task.
        if authorizationStatus == .authorized {
            start()
        }
    }

    @MainActor
    func requestAccessIfNeeded() async {
        switch authorizationStatus {
        case .authorized:
            start()
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            authorizationStatus = granted ? .authorized : .denied
            if granted { start() }
        case .denied, .restricted:
            break
        }
    }

    func start() {
        guard authorizationStatus == .authorized else { return }
        sessionQueue.async { [weak self] in
            guard let self else { return }
            self.configureIfNeeded()
            guard self.isConfigured, !self.session.isRunning else { return }
            self.session.startRunning()
        }
    }

    func stop() {
        sessionQueue.async { [weak self] in
            guard let self, self.session.isRunning else { return }
            self.session.stopRunning()
        }
    }

    private func configureIfNeeded() {
        guard !isConfigured else { return }

        session.beginConfiguration()
        defer { session.commitConfiguration() }

        // Preview-only: avoid `.photo` (still-capture pipeline is slower to start).
        if session.canSetSessionPreset(.hd1280x720) {
            session.sessionPreset = .hd1280x720
        } else {
            session.sessionPreset = .high
        }

        guard
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
            let input = try? AVCaptureDeviceInput(device: device),
            session.canAddInput(input)
        else { return }

        session.addInput(input)
        isConfigured = true
    }
}
