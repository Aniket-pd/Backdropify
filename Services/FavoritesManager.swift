import Foundation

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()

    @Published var favorites: [Wallpaper] = []

    private init() {}

    func isFavorite(wallpaper: Wallpaper) -> Bool {
        favorites.contains { $0.transitionID == wallpaper.transitionID }
    }

    func toggleFavorite(wallpaper: Wallpaper) {
        if isFavorite(wallpaper: wallpaper) {
            favorites.removeAll { $0.transitionID == wallpaper.transitionID }
        } else {
            favorites.append(wallpaper)
        }
    }
}
