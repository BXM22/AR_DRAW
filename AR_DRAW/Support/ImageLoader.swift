//
//  ImageLoader.swift
//  AR_DRAW
//

import PhotosUI
import SwiftUI
import UIKit

enum ImageLoader {
    static let maxDimension: CGFloat = 2048

    static func loadDownsampledImage(from item: PhotosPickerItem) async -> UIImage? {
        guard let data = try? await item.loadTransferable(type: Data.self) else { return nil }
        return await downsampleAsync(data: data)
    }

    /// Loads from a user-picked Files URL (security-scoped).
    static func loadDownsampledImage(fromFileURL url: URL) async -> UIImage? {
        let accessed = url.startAccessingSecurityScopedResource()
        defer {
            if accessed { url.stopAccessingSecurityScopedResource() }
        }
        guard let data = try? Data(contentsOf: url) else { return nil }
        return await downsampleAsync(data: data)
    }

    private static func downsampleAsync(data: Data) async -> UIImage? {
        await Task.detached(priority: .userInitiated) {
            downsample(data: data, maxDimension: maxDimension)
        }.value
    }

    private static func downsample(data: Data, maxDimension: CGFloat) -> UIImage? {
        let options: [CFString: Any] = [
            kCGImageSourceShouldCache: false
        ]
        guard let source = CGImageSourceCreateWithData(data as CFData, options as CFDictionary) else {
            return UIImage(data: data)
        }

        let downsampleOptions: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimension
        ]

        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, downsampleOptions as CFDictionary) else {
            return UIImage(data: data)
        }
        return UIImage(cgImage: cgImage)
    }
}
