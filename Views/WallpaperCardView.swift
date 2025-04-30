import SwiftUI

struct WallpaperCardView: View {
    let wallpaper: Wallpaper
    var showFavoriteButton: Bool = true
    @ObservedObject private var favoritesManager = FavoritesManager.shared
    @State private var animateHeart = false

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
                .frame(width: 175, height: 300)
                .clipped()
                .cornerRadius(16)

                VStack {
                    Spacer()
                    Rectangle()
                        .fill(Color(hex: "#252525").opacity(0.5))
                        .frame(height: 45)
                        .cornerRadius(16, corners: [.bottomLeft, .bottomRight])
                        .overlay(
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(wallpaper.name)
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .semibold))
                                    HStack(spacing: 4) {
                                        Image("Coin") // Customize or replace with a custom coin image
                                            .foregroundColor(.yellow)
                                            .font(.caption)
                                        Text("\(wallpaper.coin)")
                                            .foregroundColor(.white)
                                            .font(.system(size: 10, weight: .semibold))
                                    }
                                }

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
                                        Image(systemName: favoritesManager.isFavorite(wallpaper: wallpaper) ? "heart.circle.fill" : "heart.circle")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(favoritesManager.isFavorite(wallpaper: wallpaper) ? .red : .gray)
                                            .symbolEffect(.bounce, value: animateHeart)
                                            .padding(6)
                                            
                                    }
                                }
                            }
                            .padding(.horizontal, 8)
                            .padding(.bottom, 6),
                            alignment: .bottom
                        )
                }
            }
        }
        .background(Color.gray.opacity(0.2))
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
            url: "https://res.cloudinary.com/dxmwaa0nv/image/upload/v1745576498/illustrationatmosphericimag_71073153_iuoaql.png", // 🖼 sample random image URL
            coin: 10
        ),
        showFavoriteButton: true
    )
    .padding()
    .background(Color.black) // 👈 optional, to match your app style
}
