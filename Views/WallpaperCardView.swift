import SwiftUI

struct WallpaperCardView: View {
    let wallpaper: Wallpaper
    var showFavoriteButton: Bool = true
    @ObservedObject private var favoritesManager = FavoritesManager.shared
    @State private var animateHeart = false

    var body: some View {
        ZStack(alignment: .bottom) {
            // Wallpaper Image
            AsyncImage(url: URL(string: wallpaper.url)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 166, height: 220)
                    .clipped()
            } placeholder: {
                ProgressView()
                    .frame(width: 166, height: 220)
            }
            .cornerRadius(16)

            // Bottom Label Overlay
            Rectangle()
                .fill(Color.black.opacity(0.5))
                .frame(width: 166, height: 40)
                .overlay(
                    HStack {
                        HStack(spacing: 4) {
                            Image("Coin")
                                .resizable()
                                .frame(width: 12, height: 9)
                            Text("\(wallpaper.coin)")
                                .foregroundColor(.white)
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .padding(.leading, 15)

                        Spacer()

                        if showFavoriteButton {
                            Button(action: {
                                withAnimation {
                                    let isNowFavorite = !favoritesManager.isFavorite(wallpaper: wallpaper)
                                    favoritesManager.toggleFavorite(wallpaper: wallpaper)
                                    animateHeart.toggle()
                                    if isNowFavorite {
                                        let generator = UINotificationFeedbackGenerator()
                                        generator.notificationOccurred(.success)
                                    }
                                }
                            }) {
                                Image(systemName: favoritesManager.isFavorite(wallpaper: wallpaper) ? "heart.fill" : "heart")
                                    .resizable()
                                    .frame(width: 13, height: 14)
                                    .foregroundColor(favoritesManager.isFavorite(wallpaper: wallpaper) ? .red : .gray)
                                    .symbolEffect(.bounce, value: animateHeart)
                            }
                            .padding(.trailing, 15)
                        }
                    }
                )
                .cornerRadius(16, corners: [.bottomLeft, .bottomRight])
        }
        .frame(width: 166, height: 220)
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
            url: "https://res.cloudinary.com/dxmwaa0nv/image/upload/v1745576498/illustrationatmosphericimag_71073153_iuoaql.png", // 🖼 sample random image URL
            coin: 10
        ),
        showFavoriteButton: true
    )
    .padding()
    .background(Color.black) // 👈 optional, to match your app style
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
