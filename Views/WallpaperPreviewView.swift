import SwiftUI

// Define the Wallpaper struct (as it was mentioned as needed)
// Ensure this matches your actual data model.


struct WallpaperPreviewView: View {
    let wallpapers: [Wallpaper]
    @Environment(\.dismiss) var dismiss
    @State private var animateSpotlight = false

    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMMM"
        return formatter.string(from: Date())
    }

    // MARK: - Layout Constants
    // Using constants for these makes adjustments easier and code cleaner.

    // Each item takes 78% of the screen width for a neighbor-peek effect.
    private var itemWidth: CGFloat {
        UIScreen.main.bounds.width * 0.78 // Slightly smaller to show neighbors
    }

    // Height maintains iPhone 14 Pro Max lockscreen aspect ratio.
    private var itemHeight: CGFloat {
        itemWidth * (2796.0 / 1290.0) // iPhone 14 Pro Max lockscreen aspect ratio
    }

    // Spacing between wallpaper items.
    private var itemSpacing: CGFloat {
        UIScreen.main.bounds.width * 0.05 // Reduced spacing a bit for a tighter feel, adjust as needed
    }

    // Padding for the HStack to allow first/last items to center.
    // This calculation ensures that there's enough space on either side of the content
    // for the items at the beginning or end of the list to scroll to the true center of the screen.
    private var hStackHorizontalPadding: CGFloat {
        (UIScreen.main.bounds.width - itemWidth) / 2
    }

    var body: some View {
        ZStack {
            // More realistic light ray simulation using linear gradients
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.15),
                        Color.white.opacity(0.05),
                        Color.clear
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .blur(radius: 100)
                .blendMode(.screen)
                .ignoresSafeArea()

                // Optional secondary layer for depth
                RadialGradient(
                    gradient: Gradient(colors: [Color.white.opacity(0.1), Color.clear]),
                    center: .topLeading,
                    startRadius: animateSpotlight ? 100 : 60,
                    endRadius: animateSpotlight ? 600 : 400
                )
                .blendMode(.screen)
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                        animateSpotlight.toggle()
                    }
                }
            }

            // The ScrollView is the main container for the horizontally scrolling wallpapers.
            // showsIndicators: false - Hides the horizontal scroll bar for a cleaner UI.
            ScrollView(.horizontal, showsIndicators: false) {
            // HStack arranges the wallpapers horizontally.
            // Spacing is applied between each wallpaper item.
            HStack(spacing: itemSpacing) {
                ForEach(wallpapers) { wallpaper in
                    // ZStack is used to overlay controls on top of the wallpaper image.
                    ZStack {
                        // AsyncImage handles loading images from URLs asynchronously.
                        AsyncImage(url: URL(string: wallpaper.url)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    // Ensure ProgressView has a defined size to maintain layout consistency.
                                    .frame(width: itemWidth, height: itemHeight)
                                    .background(Color.gray.opacity(0.1)) // Subtle background for empty state
                            case .success(let image):
                                image
                                    .resizable()
                                    // .aspectRatio(contentMode: .fill) is a good choice for wallpapers
                                    // as it ensures the image covers the frame, cropping if necessary.
                                    .aspectRatio(contentMode: .fill)
                                    .onAppear {
                                        // Useful for debugging image loading.
                                        print("Successfully loaded wallpaper image: \(wallpaper.url)")
                                    }
                            case .failure:
                                // Provides feedback to the user if an image fails to load.
                                Color.gray
                                    .frame(width: itemWidth, height: itemHeight)
                                    .overlay(
                                        VStack {
                                            Image(systemName: "photo")
                                                .font(.largeTitle)
                                            Text("Load Failed")
                                        }
                                        .foregroundColor(.white)
                                    )
                                    .onAppear {
                                        print("Failed to load wallpaper image: \(wallpaper.url)")
                                    }
                            @unknown default:
                                // Handles any future cases that might be added to AsyncImagePhase.
                                Color.black
                                    .frame(width: itemWidth, height: itemHeight)
                                    .overlay(Text("Unknown State").foregroundColor(.white))
                                    .onAppear {
                                        print("Unknown AsyncImage phase for wallpaper image: \(wallpaper.url)")
                                    }
                            }
                        }
                        // This frame is applied to the AsyncImage content itself.
                        .frame(width: itemWidth, height: itemHeight)
                        // Clips the image content to a rounded rectangle shape.
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        // Adds a shadow for a depth effect, enhancing the visual hierarchy.
                        .shadow(color: .black.opacity(0.4), radius: 12, x: 0, y: 6)
                        .overlay(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(animateSpotlight ? 0.12 : 0.06),
                                    Color.black.opacity(0.2),
                                    Color.black.opacity(0.35)
                                ]),
                                center: .center,
                                startRadius: animateSpotlight ? 20 : 10,
                                endRadius: animateSpotlight ? 250 : 180
                            )
                            .blendMode(.overlay)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        )

                        // Overlay mimicking iPhone lock screen
                        VStack {
                            // Top: Day and Time
                            VStack(spacing: 2) {
                                Text(formattedDate)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text(formattedTime)
                                    .font(.system(size: 80, weight: .bold, design: .default))
                                    .foregroundColor(.white)
                            }
                            .padding(.top, 30)

                            Spacer()

                            // Bottom: Flashlight and Camera
                            HStack {
                                Button(action: {
                                    print("Flashlight tapped")
                                }) {
                                    Image(systemName: "flashlight.on.fill")
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .frame(width: 60, height: 60)
                                        .background(Color.black.opacity(0.4))
                                        .clipShape(Circle())
                                }

                                Spacer()

                                Button(action: {
                                    print("Camera tapped")
                                }) {
                                    Image(systemName: "camera.fill")
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .frame(width: 60, height: 60)
                                        .background(Color.black.opacity(0.4))
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.horizontal, 30)
                            .padding(.bottom, 24)
                        }
                        .frame(width: itemWidth, height: itemHeight)
                    }
                    // This frame is for the ZStack (each individual wallpaper item).
                    .frame(width: itemWidth, height: itemHeight)
                    // MARK: - Scroll Transition (Key for "Snappy" Visuals)
                    // This modifier applies dynamic effects as the view scrolls.
                    // .interactive: Effects change live with scrolling.
                    // timingCurve: .easeInOut: Creates a smooth acceleration and deceleration for the effects.
                    .scrollTransition(.interactive(timingCurve: .easeInOut), axis: .horizontal) { view, phase in
                        view
                            // Scale: Center item is 1.0, others scale down.
                            // abs(phase.value) is 0 at center, 1 at the edge of transition.
                            // 0.2 factor means side items scale down to 80% (1.0 - 0.2).
                            .scaleEffect(1.0 - abs(phase.value) * 0.2)

                            // Opacity: Center item is fully opaque, others fade.
                            // 0.3 factor means side items fade to 70% opacity (1.0 - 0.3).
                            .opacity(1.0 - abs(phase.value) * 0.3)

                            // 3D Rotation: Items rotate on Y-axis.
                            // phase.value * -30: Creates a rotation up to 30 degrees.
                            // Negative value often gives a pleasing perspective.
                            // anchor: Changes the anchor point of rotation for a more dynamic feel.
                            .rotation3DEffect(
                                .degrees(phase.value * -30),
                                axis: (x: 0, y: 1, z: 0),
                                anchor: phase.value < 0 ? .leading : .trailing, // Rotates away from the direction of movement
                                perspective: 0.3 // Adds a subtle perspective
                            )

                            // Horizontal Offset: Creates a slight "tucked in" or perspective effect.
                            // Moves items horizontally based on their phase.
                            // itemWidth / 8: Adjust this divisor to control the magnitude of the offset.
                            .offset(x: phase.value * (itemWidth / -8)) // Negative offset for a slight "pull" effect
                    }
                }
            }
            // MARK: - Centering Logic for HStack Content
            // This padding is crucial for allowing the first and last items to be centered in the ScrollView.
            // It adds space to the left of the first item and right of the last item.
            .padding(.horizontal, hStackHorizontalPadding)
        }
        .scrollTargetLayout()
        // MARK: - Snappy Scrolling Behavior
        // .viewAligned is THE key to making the ScrollView snap items to the center (or leading edge based on context).
        // When the user finishes scrolling, the ScrollView automatically animates to align the nearest item.
        .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
        // .ignoresSafeArea() allows the wallpaper preview to extend into the screen's safe areas
        // for a more immersive experience.
        .ignoresSafeArea()
        // .scrollBounceBehavior can be useful but .viewAligned often provides the desired carousel feel.
        // .basedOnSize is generally a good default if you want bounce.
        .scrollBounceBehavior(.basedOnSize)
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

// Helper for control buttons for cleaner code in the main view.
struct ControlButton: View {
    let systemName: String
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) { // Added spacing for better visual separation
                Image(systemName: systemName)
                    .font(.title2)
                Text(text)
                    .font(.caption)
                    .lineLimit(1) // Ensure text doesn't wrap awkwardly
            }
            .padding(.vertical, 4) // Minimal vertical padding
            .frame(minWidth: 60) // Ensure a minimum tappable width
            .foregroundColor(.white)
        }
    }
}


// MARK: - Preview
struct WallpaperPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        // Sample data for the preview
        // Using diverse and actual image URLs will make the preview more representative.
        // Ensure these URLs are accessible. Consider using placeholder services if actual URLs are unstable for previews.
        WallpaperPreviewView(wallpapers: [
            Wallpaper(id: "1", name: "Aurora Dream", url: "https://res.cloudinary.com/dxmwaa0nv/image/upload/v1747080151/IMG_5167_d1d6ny.jpg", coin: 10),
            Wallpaper(id: "2", name: "Crimson Peaks", url: "https://res.cloudinary.com/dxmwaa0nv/image/upload/v1746215697/IMG_5081_w5tbvj.jpg", coin: 15)
            
        ])
    }
}
