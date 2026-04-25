import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoritesManager = FavoritesManager.shared
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Namespace private var wallpaperZoomNamespace
    
    // 2-column grid like CollectionDetailView
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if favoritesManager.favorites.isEmpty {
                    VStack {
                        Spacer()
                        Text("No favorites yet!")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(favoritesManager.favorites) { wallpaper in
                            NavigationLink(value: wallpaper) {
                                WallpaperCardView(wallpaper: wallpaper, showFavoriteButton: false)
                            }
                            .buttonStyle(.plain)
                            .matchedTransitionSource(id: wallpaper.transitionID, in: wallpaperZoomNamespace) { source in
                                source
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.black.ignoresSafeArea())
            .navigationDestination(for: Wallpaper.self) { wallpaper in
                if reduceMotion {
                    FullscreenWallpaperView(wallpaper: wallpaper, collectionName: "Favorites")
                        .navigationTransition(.automatic)
                } else {
                    FullscreenWallpaperView(wallpaper: wallpaper, collectionName: "Favorites")
                        .navigationTransition(.zoom(sourceID: wallpaper.transitionID, in: wallpaperZoomNamespace))
                }
            }
        }
    }
}
