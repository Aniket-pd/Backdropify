import Foundation

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()

    @Published var favorites: [Wallpaper] = []

    private init() {}

    func isFavorite(wallpaper: Wallpaper) -> Bool {
        favorites.contains(where: { $0.id == wallpaper.id })
    }

    func toggleFavorite(wallpaper: Wallpaper) {
        if isFavorite(wallpaper: wallpaper) {
            favorites.removeAll(where: { $0.id == wallpaper.id })
        } else {
            favorites.append(wallpaper)
        }
    }
}
