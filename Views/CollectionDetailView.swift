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
                WallpaperCardView(
                    wallpaper: wallpaper,
                    showFavoriteButton: false,
                    showsBottomBar: false
                )
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
        Wallpaper(id: "2", name: "ogo", url: "https://picsum.photos/200/301"),
        Wallpaper(id: "3", name: "wall3", url: "https://picsum.photos/200/302"),
        Wallpaper(id: "4", name: "wall4", url: "https://picsum.photos/200/303"),
        Wallpaper(id: "5", name: "wall5", url: "https://picsum.photos/200/304"),
        Wallpaper(id: "6", name: "wall6", url: "https://picsum.photos/200/305"),
        Wallpaper(id: "7", name: "wall7", url: "https://picsum.photos/200/306"),
        Wallpaper(id: "8", name: "wall8", url: "https://picsum.photos/200/307"),
        Wallpaper(id: "9", name: "wall9", url: "https://picsum.photos/200/308"),
        Wallpaper(id: "10", name: "wall10", url: "https://picsum.photos/200/309"),
        Wallpaper(id: "11", name: "wall11", url: "https://picsum.photos/200/310"),
        Wallpaper(id: "12", name: "wall12", url: "https://picsum.photos/200/311"),
        Wallpaper(id: "13", name: "wall13", url: "https://picsum.photos/200/312"),
        Wallpaper(id: "14", name: "wall14", url: "https://picsum.photos/200/313"),
        Wallpaper(id: "15", name: "wall15", url: "https://picsum.photos/200/314"),
        Wallpaper(id: "16", name: "wall16", url: "https://picsum.photos/200/315"),
        Wallpaper(id: "17", name: "wall17", url: "https://picsum.photos/200/316"),
        Wallpaper(id: "18", name: "wall18", url: "https://picsum.photos/200/317"),
        Wallpaper(id: "19", name: "wall19", url: "https://picsum.photos/200/318"),
        Wallpaper(id: "20", name: "wall20", url: "https://picsum.photos/200/319"),
        Wallpaper(id: "21", name: "wall21", url: "https://picsum.photos/200/320"),
        Wallpaper(id: "22", name: "wall22", url: "https://picsum.photos/200/321")
    ]

    let viewModel = WallpapersByCollectionViewModel()
    viewModel.wallpapers = dummyWallpapers

    return NavigationStack {
        CollectionDetailView(collection: sampleCollection, viewModel: viewModel)
    }
}
