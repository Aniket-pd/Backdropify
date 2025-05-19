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
    VStack(spacing: 18) {
            Text(collection.name)
                .font(.system(size: 28))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top,22)
                .colorInvert()
            
            Divider()
            .frame(width: 302, height: 0.2)
                .overlay(.white)
                .padding(.bottom, 10)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.wallpapers) { wallpaper in
                        NavigationLink(destination: FullscreenWallpaperView(wallpaper: wallpaper)) {
                            WallpaperCardView(wallpaper: wallpaper, showFavoriteButton: true)
                        }
                    }
                }
                .padding(.top, 0)
                .padding([.leading, .trailing])
            }
        }
        .fullScreenCover(isPresented: $showFullScreenPreview) {
            NavigationView {
                WallpaperPreviewView(wallpapers: viewModel.wallpapers)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                showFullScreenPreview = false
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                            }
                        }
                    }
            }
        }
        .background(Color(red: 20/255, green: 20/255, blue: 20/255).ignoresSafeArea())
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
        //.navigationTitle(collection.name)
        .navigationBarTitleDisplayMode(.inline)
        .tint(.white)
        .toolbarBackground(.black)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showFullScreenPreview.toggle()
                }) {
                    Image(systemName: "iphone.app.switcher")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 1) {
                    Image(systemName: "Coin")
                    Text("999")
                }
                .font(.system(size: 16))
            }
        }
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
