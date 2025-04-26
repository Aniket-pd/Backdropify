import SwiftUI

struct CollectionDetailView: View {
    let collection: WallpaperCollection
    @StateObject private var viewModel = WallpapersByCollectionViewModel()
    @StateObject private var favoritesManager = FavoritesManager.shared
    
    // 1️⃣ Define the grid structure: 2 columns
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.wallpapers) { wallpaper in
                    WallpaperCardView(wallpaper: wallpaper, showFavoriteButton: true)
                }
            }
            .padding()
        }
        .navigationTitle(collection.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let collectionID = collection.id {
                viewModel.fetchWallpapers(from: collectionID)
                print("Collection ID: \(collectionID)")
            } else {
                print("Collection ID is nil")
            }
        }
        .background(Color.black.ignoresSafeArea())
    }
}
