import SwiftUI
import Shimmer

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct OffsetObservingView: View {
    var body: some View {
        GeometryReader { geo in
            Color.clear
                .preference(key: ScrollOffsetPreferenceKey.self, value: geo.frame(in: .named("scroll")).minY)
        }
    }
}

struct AnimatedCollectionDetailView: View {
    let collection: WallpaperCollection
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var animateIn = false

    var body: some View {
        CollectionDetailView(collection: collection)
            .opacity(animateIn ? 1 : 0)
            .blur(radius: animateIn ? 0 : 20)
            .onAppear {
                if reduceMotion {
                    animateIn = true
                } else {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        animateIn = true
                    }
                }
            }
    }
}

struct HomeView: View {
    
    @State private var scrollOffset: CGFloat = 0
    @State private var currentIndex = 0
    @State private var isBlurred = false
    @State private var isImageLoaded = false
    //--------------
    @StateObject private var collectionsVM = WallpaperCollectionsViewModel()
    @State private var selectedCollection: WallpaperCollection?
    @State private var showCollection = false
    
    //----------------------
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    private let imageNames = [
        "WALLP2 1",
        "PreviewWallpaper",
        "photographyportraitofcontr_64338086 (1)",
        "WALLP4"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    OffsetObservingView()
                    ZStack(alignment: .bottom) {
                        TabView(selection: $currentIndex) {
                            ForEach(0..<imageNames.count, id: \.self) { index in
                                Image(imageNames[index])
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipped()
                                    .tag(index)
                            }
                        }
                        .modifier(StretchyHeaderViewModifier(startingHeight: UIScreen.main.bounds.height * 0.65))
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                        .onReceive(timer) { _ in
                            withAnimation {
                                currentIndex = (currentIndex + 1) % imageNames.count
                            }
                        }
                        
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0.5),
                                                                Color.black.opacity(0.75)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(height: 260)
                            .offset(y: 20)
                            .allowsHitTesting(false)
                    }
                
                Text("Collection")
                    .font(.system(size: 20, weight: .semibold, design: .default))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 21)
                    .padding(.top, 20)
                
                LazyVGrid(columns: [GridItem(.fixed(169), spacing: 12), GridItem(.fixed(169), spacing: 12)], spacing: 12) {
                    ForEach(collectionsVM.collections) { collection in
                        NavigationLink(
                            destination: AnimatedCollectionDetailView(collection: collection)
                        ) {
                            ZStack(alignment: .bottomLeading) {
                                AsyncImage(url: URL(string: collection.url)) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .opacity(isImageLoaded ? 1 : 0)
                                            .onAppear {
                                                withAnimation(.easeInOut(duration: 0.3)) {
                                                    isImageLoaded = true
                                                }
                                            }

                                    case .failure(_):
                                        Color.gray.opacity(0.3)
                                            .cornerRadius(14)

                                    case .empty:
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(Color.gray.opacity(0.3))
                                            .redacted(reason: .placeholder)
                                            .shimmering()

                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                .frame(width: 169, height: 118)
                                .clipped()
                                .cornerRadius(14)

                                Text(collection.name)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.leading, 16)
                                    .padding(.bottom, 15)
                            }
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 2), value: showCollection)
                        }
                        .simultaneousGesture(
                            TapGesture().onEnded {
                                isBlurred = true
                            }
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                }
                .blur(radius: isBlurred ? 20 : 0)
                .animation(.easeInOut(duration: 0.3), value: isBlurred)
                .coordinateSpace(name: "scroll")
                .onAppear {
                
                    collectionsVM.fetchCollections()
                    isBlurred = false
                }
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    withAnimation(.easeInOut(duration: 6)) {
                        scrollOffset = value
                    }
                }
                .background(Color.black)
                .ignoresSafeArea()
            }
            .background(Color.black)
        }
        .background(Color.black)
    }
}

#Preview {
    HomeView()
}
