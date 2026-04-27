import SwiftUI
import ImageIO
import UIKit

struct OptimizedWallpaperImage<Placeholder: View, Failure: View>: View {
    let urlString: String
    let targetSize: CGSize
    var placeholderSize: CGSize?
    let contentMode: ContentMode
    @ViewBuilder let placeholder: () -> Placeholder
    @ViewBuilder let failure: () -> Failure

    @Environment(\.displayScale) private var displayScale
    @StateObject private var loader = OptimizedWallpaperImageLoader()

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else if loader.didFail {
                failure()
            } else {
                placeholder()
            }
        }
        .task(id: requestID) {
            loader.load(
                urlString: urlString,
                targetSize: targetSize,
                placeholderSize: placeholderSize,
                displayScale: displayScale
            )
        }
        .onDisappear {
            loader.cancel()
        }
    }

    private var requestID: String {
        let width = Int(targetSize.width.rounded())
        let height = Int(targetSize.height.rounded())
        let scale = Int(displayScale.rounded())
        return "\(urlString)|\(width)x\(height)@\(scale)"
    }
}

@MainActor
final class OptimizedWallpaperImageLoader: ObservableObject {
    @Published private(set) var image: UIImage?
    @Published private(set) var didFail = false

    private var loadTask: Task<Void, Never>?

    func load(urlString: String, targetSize: CGSize, placeholderSize: CGSize?, displayScale: CGFloat) {
        guard !targetSize.isEmpty else {
            didFail = false
            return
        }

        guard let url = URL(string: urlString) else {
            didFail = true
            return
        }

        loadTask?.cancel()
        didFail = false

        let normalizedTarget = targetSize.normalizedForCaching
        let normalizedPlaceholder = placeholderSize?.normalizedForCaching

        image = WallpaperImageStore.cachedImage(
            for: url,
            targetSize: normalizedTarget,
            displayScale: displayScale
        )

        if image == nil, let normalizedPlaceholder {
            image = WallpaperImageStore.cachedImage(
                for: url,
                targetSize: normalizedPlaceholder,
                displayScale: displayScale
            )
        }

        loadTask = Task {
            let loadedImage = await WallpaperImageStore.pipeline.image(
                for: url,
                targetSize: normalizedTarget,
                displayScale: displayScale
            )

            guard !Task.isCancelled else { return }

            if let loadedImage {
                image = loadedImage
                didFail = false
            } else if image == nil {
                didFail = true
            }
        }
    }

    func cancel() {
        loadTask?.cancel()
        loadTask = nil
    }
}

private enum WallpaperImageStore {
    static let cache = NSCache<NSString, UIImage>()
    static let pipeline = WallpaperImagePipeline()

    static func cachedImage(for url: URL, targetSize: CGSize, displayScale: CGFloat) -> UIImage? {
        cache.object(forKey: cacheKey(for: url, targetSize: targetSize, displayScale: displayScale))
    }

    static func cacheKey(for url: URL, targetSize: CGSize, displayScale: CGFloat) -> NSString {
        let width = Int(targetSize.width.rounded())
        let height = Int(targetSize.height.rounded())
        let scale = Int(displayScale.rounded())
        return "\(url.absoluteString)|\(width)x\(height)@\(scale)" as NSString
    }
}

private actor WallpaperImagePipeline {
    private var inFlightTasks: [NSString: Task<UIImage?, Never>] = [:]

    func image(for url: URL, targetSize: CGSize, displayScale: CGFloat) async -> UIImage? {
        let cacheKey = WallpaperImageStore.cacheKey(for: url, targetSize: targetSize, displayScale: displayScale)

        if let cachedImage = WallpaperImageStore.cache.object(forKey: cacheKey) {
            return cachedImage
        }

        if let inFlightTask = inFlightTasks[cacheKey] {
            return await inFlightTask.value
        }

        let task = Task<UIImage?, Never> {
            let loadedImage = await Self.fetchImage(for: url, targetSize: targetSize, displayScale: displayScale)

            if let loadedImage {
                WallpaperImageStore.cache.setObject(loadedImage, forKey: cacheKey)
            }

            return loadedImage
        }

        inFlightTasks[cacheKey] = task
        let image = await task.value
        inFlightTasks[cacheKey] = nil
        return image
    }

    private static func fetchImage(for url: URL, targetSize: CGSize, displayScale: CGFloat) async -> UIImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return downsampledImage(data: data, targetSize: targetSize, displayScale: displayScale)
        } catch {
            return nil
        }
    }

    private static func downsampledImage(data: Data, targetSize: CGSize, displayScale: CGFloat) -> UIImage? {
        let sourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary

        guard let imageSource = CGImageSourceCreateWithData(data as CFData, sourceOptions) else {
            return nil
        }

        let maxPixelSize = max(targetSize.width, targetSize.height) * max(displayScale, 1)
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixelSize
        ] as CFDictionary

        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }
}

private extension CGSize {
    var isEmpty: Bool {
        width <= 0 || height <= 0
    }

    var normalizedForCaching: CGSize {
        CGSize(width: max(width.rounded(), 1), height: max(height.rounded(), 1))
    }
}
