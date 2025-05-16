import SwiftUI

struct WallpaperPreviewView: View {
    let wallpapers: [Wallpaper]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(wallpapers) { wallpaper in
                    ZStack {
                        // Full-screen wallpaper image
                        AsyncImage(url: URL(string: wallpaper.url)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .onAppear {
                                        print("Loading wallpaper image: \(wallpaper.url) [empty]")
                                    }
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .ignoresSafeArea()
                                    .onAppear {
                                        print("Successfully loaded wallpaper image: \(wallpaper.url)")
                                    }
                            case .failure:
                                Color.gray
                                    .onAppear {
                                        print("Failed to load wallpaper image: \(wallpaper.url)")
                                    }
                            @unknown default:
                                Color.black
                                    .onAppear {
                                        print("Unknown AsyncImage phase for wallpaper image: \(wallpaper.url)")
                                    }
                            }
                        }
                        
                        VStack {
                            // Top navigation bar
                            HStack {
                                Button(action: { dismiss() }) {
                                    Image(systemName: "chevron.left")
                                        .padding()
                                        .background(Color.black.opacity(0.5))
                                        .clipShape(Circle())
                                }
                                Spacer()
                                HStack {
                                    Image(systemName: "bitcoinsign.circle.fill")
                                    Text("\(wallpaper.coin)")
                                }
                                .padding()
                                .background(Color.black.opacity(0.5))
                                .clipShape(Capsule())
                            }
                            .padding()
                            
                            Spacer()
                            
                            // Bottom panel
                            HStack {
                                Spacer()
                                Button(action: { print("Info button pressed") }) {
                                    VStack {
                                        Image(systemName: "info.circle.fill")
                                        Text("Info")
                                    }
                                }
                                Spacer()
                                Button(action: { print("Download button pressed") }) {
                                    VStack {
                                        Image(systemName: "arrow.down.circle.fill")
                                        Text("Download")
                                    }
                                }
                                Spacer()
                                Button(action: { print("Preview button pressed") }) {
                                    VStack {
                                        Image(systemName: "iphone")
                                        Text("Preview")
                                    }
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color.black.opacity(0.5))
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .containerRelativeFrame(.vertical, alignment: .center)
                }
            }
        }
        .ignoresSafeArea()
        .scrollTargetLayout()
        .scrollTargetBehavior(.paging)
        .scrollBounceBehavior(.basedOnSize)
    }
    
    
    // MARK: - Preview
    struct WallpaperPreviewView_Previews: PreviewProvider {
        static var previews: some View {
            WallpaperPreviewView(wallpapers: [
                Wallpaper(id: "1", name: "Sample 1", url: "https://res.cloudinary.com/dxmwaa0nv/image/upload/v1746215697/IMG_5081_w5tbvj.jpg", coin: 10),
                Wallpaper(id: "2", name: "Sample 2", url: "https://res.cloudinary.com/dxmwaa0nv/image/upload/v1746215697/IMG_5082_example.jpg", coin: 15)
            ])
        }
    }
}
