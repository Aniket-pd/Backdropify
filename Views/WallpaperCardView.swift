import SwiftUI

struct WallpaperCardView: View {
    let wallpaper: Wallpaper
    var showFavoriteButton: Bool = true
    @ObservedObject private var favoritesManager = FavoritesManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: wallpaper.url)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 150)
                .clipped()
                .cornerRadius(16)

                if showFavoriteButton {
                    Button(action: {
                        favoritesManager.toggleFavorite(wallpaper: wallpaper)
                    }) {
                        Image(systemName: favoritesManager.isFavorite(wallpaper: wallpaper) ? "heart.fill" : "heart")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.red)
                            .padding(8)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    }
                    .padding(10)
                }
            }

            Text("\(wallpaper.coin) Coins")
                .foregroundColor(.white)
                .font(.caption)
                .padding(.leading, 4)
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(16)
    }
}

#Preview {
    WallpaperCardView(
        wallpaper: Wallpaper(
            id: "sample-id",
            name: "Sample Wallpaper",
            url: "https://res.cloudinary.com/dxmwaa0nv/image/upload/v1745576498/illustrationatmosphericimag_71073153_iuoaql.png", // 🖼 sample random image URL
            coin: 10
        ),
        showFavoriteButton: true
    )
    .padding()
    .background(Color.black) // 👈 optional, to match your app style
}
