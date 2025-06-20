import Foundation

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()

    @Published var favorites: [Wallpaper] = []

    private init() {}

    func isFavorite(wallpaper: Wallpaper) -> Bool {
        guard let id = wallpaper.id else { return false }
        return favorites.contains { $0.id == id }
    }

    func toggleFavorite(wallpaper: Wallpaper) {
        if isFavorite(wallpaper: wallpaper) {
            guard let id = wallpaper.id else { return }
            favorites.removeAll { $0.id == id }
        } else {
            favorites.append(wallpaper)
        }
    }
}
