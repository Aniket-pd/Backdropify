import SwiftUI

struct CollectionDetailView: View {
    let collection: WallpaperCollection
    @StateObject private var viewModel: WallpapersByCollectionViewModel
    @Environment(\.presentationMode) private var presentationMode
    @State private var showFullScreenPreview = false
    
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
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.wallpapers) { wallpaper in
                        NavigationLink(destination: FullscreenWallpaperView(wallpaper: wallpaper)) {
                            WallpaperCardView(wallpaper: wallpaper, showFavoriteButton: true)
                        }
                    }
                }
                .padding([.leading, .trailing])
                .padding(.top, 100) // so grid doesn't overlap the top bar
            }

            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color(red: 36/255, green: 35/255, blue: 35/255))
                                .frame(width: 36, height: 36)
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .bold))
                        }
                    }
                    .padding(.leading, 24)

                    Text(collection.name)
                        .font(.system(size: 21, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.leading, 12)

                    Spacer()

                    HStack(spacing: 16) {
                        Button(action: {
                            showFullScreenPreview = true
                        }) {
                            Image(systemName: "rectangle.stack.fill")
                                .foregroundColor(.white)
                        }

                        HStack(spacing: 4) {
                            Image(systemName: "bitcoinsign.circle.fill")
                                .foregroundColor(.white)
                            Text("999") // dummy value
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.trailing, 24)
                    
                }
                .frame(height: 70)
                .padding(.top, 50)
                .background(
                    ZStack {
                        Color.clear.background(.ultraThinMaterial)
                        Color.black.opacity(0.75)
                    }
                )
                .ignoresSafeArea(edges: .top)
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 4)
                Spacer()
            }
        }
        .onAppear {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
                if let collectionID = collection.id {
                    viewModel.fetchWallpapers(from: collectionID)
                    print("Fetching wallpapers from: \(collectionID)")
                } else {
                    print("Collection ID is nil")
                }
            }
        }
        .fullScreenCover(isPresented: $showFullScreenPreview) {
            NavigationView {
                WallpaperPreviewView(wallpapers: viewModel.wallpapers)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
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
