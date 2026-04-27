import SwiftUI

struct WallpaperCardView: View {
    let wallpaper: Wallpaper
    var showFavoriteButton: Bool = true
    var showsBottomBar: Bool = true
    @ObservedObject private var favoritesManager = FavoritesManager.shared
    @State private var animateHeart = false

    var body: some View {
        ZStack(alignment: .bottom) {
            wallpaperImage

            if showsBottomBar {
                Rectangle()
                    .fill(Color.black.opacity(0.5))
                    .frame(width: 166, height: 40)
                    .overlay(
                        HStack {
                            Spacer()

                            if showFavoriteButton {
                                Button(action: {
                                    let isNowFavorite = !favoritesManager.isFavorite(wallpaper: wallpaper)
                                    favoritesManager.toggleFavorite(wallpaper: wallpaper)
                                    animateHeart.toggle()
                                    if isNowFavorite {
                                        let generator = UINotificationFeedbackGenerator()
                                        generator.notificationOccurred(.success)
                                    }
                                }) {
                                    Image(systemName: favoritesManager.isFavorite(wallpaper: wallpaper) ? "heart.fill" : "heart")
                                        .resizable()
                                        .frame(width: 14, height: 13)
                                        .foregroundStyle(favoritesManager.isFavorite(wallpaper: wallpaper) ? .red : .gray)
                                        .symbolEffect(.bounce, value: animateHeart)
                                }
                                .padding(.trailing, 15)
                            }
                        }
                    )
                    .cornerRadius(16, corners: [.bottomLeft, .bottomRight])
            }
        }
        .frame(width: 166, height: 220)
    }

    private var wallpaperImage: some View {
        OptimizedWallpaperImage(
            targetSize: CGSize(width: 166, height: 220),
            contentMode: .fill
        ) {
            ProgressView()
                .frame(width: 166, height: 220)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.2))
        } failure: {
            ZStack {
                Color.gray.opacity(0.25)
                Image(systemName: "photo")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.75))
            }
            .frame(width: 166, height: 220)
        }
        .frame(width: 166, height: 220)
        .clipped()
        .cornerRadius(16)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    WallpaperCardView(
        wallpaper: Wallpaper(
            id: "sample-id",
            name: "Sample Wallpaper",
            url: "https://res.cloudinary.com/dxmwaa0nv/image/upload/v1745576498/illustrationatmosphericimag_71073153_iuoaql.png" // 🖼 sample random image URL
        ),
        showFavoriteButton: true
    )
    .padding()
    .background(Color.black) // 👈 optional, to match your app style
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
