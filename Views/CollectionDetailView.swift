import SwiftUI

struct CollectionDetailView: View {
    let collection: WallpaperCollection
    @StateObject private var viewModel = WallpapersByCollectionViewModel()
    
    // 1️⃣ Define the grid structure: 2 columns
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) { // 2️⃣ Use LazyVGrid instead of LazyVStack
                ForEach(viewModel.wallpapers) { wallpaper in
                    VStack(alignment: .leading, spacing: 8) {
                        AsyncImage(url: URL(string: wallpaper.url)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: 150) // 🎯 Slightly smaller for a nice grid look
                        .clipped()
                        .cornerRadius(16)
                        
                        // favorite button
                        Button(action: {
                            FavoritesManager.shared.toggleFavorite(wallpaper: wallpaper)
                        }) {
                            Image(systemName: FavoritesManager.shared.isFavorite(wallpaper: wallpaper) ? "heart.fill" : "heart")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.red)
                                .padding(8)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                        }
                        .padding(10)
                        
                        
                        Text("\(wallpaper.coin) Coins") // 3️⃣ Display the coin value if you want
                            .foregroundColor(.white)
                            .font(.caption)
                            .padding(.leading, 4)
                    }
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(16)
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
