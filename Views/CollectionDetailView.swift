import SwiftUI

struct CollectionDetailView: View {
    let collection: WallpaperCollection
    @StateObject private var viewModel: WallpapersByCollectionViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showFullScreenPreview = false
    @State private var animatingFavoriteWallpaperID: String?
    @Namespace private var wallpaperZoomNamespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    init(collection: WallpaperCollection, viewModel: WallpapersByCollectionViewModel = WallpapersByCollectionViewModel()) {
        self.collection = collection
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    @StateObject private var favoritesManager = FavoritesManager.shared
    
    // 1️⃣ Define the grid structure: adaptive columns with minimum width 160 and spacing 16
    private let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.wallpapers) { wallpaper in
                        wallpaperCard(for: wallpaper)
                    }
                }
                .padding([.leading, .trailing])
                .padding(.top, 100)
            }
        }
        .overlay(alignment: .top) {
            topBar
        }
        .onAppear {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
                viewModel.fetchWallpapers(from: collection.id)
                print("Fetching wallpapers from: \(collection.id)")
            }
        }
        .fullScreenCover(isPresented: $showFullScreenPreview) {
            NavigationStack {
                WallpaperPreviewView(wallpapers: viewModel.wallpapers)
            }
        }
        .navigationDestination(for: Wallpaper.self) { wallpaper in
            fullscreenDestination(for: wallpaper)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

    @ViewBuilder
    private func fullscreenDestination(for wallpaper: Wallpaper) -> some View {
        if reduceMotion {
            FullscreenWallpaperView(wallpaper: wallpaper, collectionName: collection.name)
                .navigationTransition(.automatic)
        } else {
            FullscreenWallpaperView(wallpaper: wallpaper, collectionName: collection.name)
                .navigationTransition(.zoom(sourceID: wallpaper.transitionID, in: wallpaperZoomNamespace))
        }
    }

    private func wallpaperCard(for wallpaper: Wallpaper) -> some View {
        ZStack(alignment: .bottomTrailing) {
            NavigationLink(value: wallpaper) {
                WallpaperCardView(wallpaper: wallpaper, showFavoriteButton: false)
                    .frame(maxWidth: .infinity)
                    .aspectRatio(3/4, contentMode: .fit)
            }
            .buttonStyle(.plain)
            .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .matchedTransitionSource(id: wallpaper.transitionID, in: wallpaperZoomNamespace) { source in
                source
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }

            favoriteButton(for: wallpaper)
                .padding(.trailing, 15)
                .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity)
    }

    private func favoriteButton(for wallpaper: Wallpaper) -> some View {
        Button {
            let isNowFavorite = !favoritesManager.isFavorite(wallpaper: wallpaper)
            favoritesManager.toggleFavorite(wallpaper: wallpaper)
            animatingFavoriteWallpaperID = wallpaper.transitionID

            if isNowFavorite {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
        } label: {
            Image(systemName: favoritesManager.isFavorite(wallpaper: wallpaper) ? "heart.fill" : "heart")
                .resizable()
                .frame(width: 14, height: 13)
                .foregroundColor(favoritesManager.isFavorite(wallpaper: wallpaper) ? .red : .gray)
                .symbolEffect(.bounce, value: animatingFavoriteWallpaperID)
        }
        .buttonStyle(.plain)
        .frame(width: 32, height: 32)
        .contentShape(Rectangle())
    }

    private var topBar: some View {
        HStack {
            Button(action: {
                dismiss()
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

            Button(action: {
                showFullScreenPreview = true
            }) {
                Image(systemName: "rectangle.stack.fill")
                    .foregroundColor(.white)
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
    }
}
    #Preview {
    let sampleCollection = WallpaperCollection(
        id: "abstract_art",
        name: "Abstract Art",
        url: "https://picsum.photos/200/300"
    )

    let dummyWallpapers = [
        Wallpaper(id: "1", name: "ap", url: "https://res.cloudinary.com/dxmwaa0nv/image/upload/v1745576498/illustrationatmosphericimag_71073153_iuoaql.png"),
        Wallpaper(id: "2", name: "ogo", url: "https://picsum.photos/200/301")
    ]

    let viewModel = WallpapersByCollectionViewModel()
    viewModel.wallpapers = dummyWallpapers

    return NavigationStack {
        CollectionDetailView(collection: sampleCollection, viewModel: viewModel)
    }
}
