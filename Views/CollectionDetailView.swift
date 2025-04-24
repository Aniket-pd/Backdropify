import SwiftUI

struct CollectionDetailView: View {
    let collection: WallpaperCollection
    @StateObject private var viewModel = WallpapersByCollectionViewModel()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(viewModel.wallpapers) { wallpaper in
                    VStack(alignment: .leading, spacing: 8) {
                        AsyncImage(url: URL(string: wallpaper.url)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(16)
                        
                        
                    }
                    .padding(.horizontal)
                }
            }
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
