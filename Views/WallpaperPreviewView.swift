import SwiftUI

struct WallpaperPreviewView: View {
    let wallpaper: Wallpaper
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Full screen wallpaper image
            wallpaperImage
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top navigation bar
                topNavigationBar
                
                Spacer()
                
                // Bottom tab view
                bottomTabView
            }
            .ignoresSafeArea(.keyboard)
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }
    
    // MARK: - Wallpaper Image
    private var wallpaperImage: some View {
        AsyncImage(url: URL(string: wallpaper.url)) { phase in
            switch phase {
            case .empty:
                ZStack {
                    Color.black
                    ProgressView()
                        .tint(.white)
                }
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                ZStack {
                    Color.gray
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
            @unknown default:
                Color.black
            }
        }
    }
    
    // MARK: - Top Navigation Bar
    private var topNavigationBar: some View {
        HStack {
            // Back button
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.black.opacity(0.35))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            // Coin display
            HStack(spacing: 6) {
                Image(systemName: "bitcoinsign.circle.fill")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("\(wallpaper.coin)")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color.black.opacity(0.35))
            .clipShape(Capsule())
        }
        .padding(.horizontal, 16)
        .padding(.top, 48)
    }
    
    // MARK: - Bottom Tab View
    private var bottomTabView: some View {
        HStack(spacing: 0) {
            Spacer()
            
            // Information button
            tabButton(
                icon: "info.circle.fill",
                label: "Info",
                action: {
                    print("Information button pressed")
                }
            )
            
            Spacer()
            
            // Download button
            tabButton(
                icon: "arrow.down.circle.fill",
                label: "Download",
                action: {
                    print("Download button pressed")
                }
            )
            
            Spacer()
            
            // iPhone Preview button
            tabButton(
                icon: "iphone",
                label: "Preview",
                action: {
                    print("iPhone Preview button pressed")
                }
            )
            
            Spacer()
        }
        .padding(.vertical, 20)
        .background(
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0.5)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
    }
    
    // MARK: - Tab Button
    private func tabButton(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
            .frame(width: 80)
        }
    }
}

// MARK: - Preview
struct WallpaperPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        WallpaperPreviewView(wallpaper: Wallpaper(id: "1", name: "Sample Wallpaper", url: "https://res.cloudinary.com/dxmwaa0nv/image/upload/v1746215697/IMG_5081_w5tbvj.jpg", coin: 10))
    }
}
