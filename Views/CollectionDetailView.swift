import SwiftUI

struct CollectionDetailView: View {
    let collection: WallpaperCollection
    @StateObject private var viewModel: WallpapersByCollectionViewModel

    init(collection: WallpaperCollection, viewModel: WallpapersByCollectionViewModel = WallpapersByCollectionViewModel()) {
        self.collection = collection
        _viewModel = StateObject(wrappedValue: viewModel)
    }
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
                    NavigationLink(destination: WallpaperPreviewView(wallpaper: wallpaper)) {
                        WallpaperCardView(wallpaper: wallpaper, showFavoriteButton: true)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(collection.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Prevent fetching during SwiftUI preview
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
                if let collectionID = collection.id {
                    viewModel.fetchWallpapers(from: collectionID)
                    print("Collection ID: \(collectionID)")
                } else {
                    print("Collection ID is nil")
                }
            }
        }
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    let sampleCollection = WallpaperCollection(
        id: "abstract_art",
        name: "Abstract Art",
        url: "https://picsum.photos/200/300"
    )

    let dummyWallpapers = [
        Wallpaper(id: "1", name: "ap", url: "https://res.cloudinary.com/dxmwaa0nv/image/upload/v1745576498/illustrationatmosphericimag_71073153_iuoaql.png", coin: 10),
        Wallpaper(id: "2", name: "ogo", url: "https://picsum.photos/200/301", coin: 20)
    ]

    let viewModel = WallpapersByCollectionViewModel()
    viewModel.wallpapers = dummyWallpapers

    return NavigationView {
        CollectionDetailView(collection: sampleCollection, viewModel: viewModel)
    }
}
