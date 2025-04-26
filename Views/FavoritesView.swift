import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoritesManager = FavoritesManager.shared
    
    // 2-column grid like CollectionDetailView
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
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
                            WallpaperCardView(wallpaper: wallpaper, showFavoriteButton: false)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.black.ignoresSafeArea())
        }
    }
}
