import SwiftUI

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

struct HomeView: View {
    
    @State private var scrollOffset: CGFloat = 0
    @State private var currentIndex = 0
    //--------------
    @StateObject private var collectionsVM = WallpaperCollectionsViewModel()
    @State private var selectedCollection: WallpaperCollection?
    @State private var showCollection = false
    
    //----------------------
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    private let imageNames = [
        "Afuturisticneonlitstreeta_18295513",
        "Naturescenelandscapeview_88300727",
        "photographyportraitofcontr_64338086 (1)"
    ]
    
    var body: some View {
        NavigationView {
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
                    .modifier(StretchyHeaderViewModifier(startingHeight: UIScreen.main.bounds.height * 0.69))
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
                                                            Color.black.opacity(1)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 150)
                        .offset(y: 10)
                        .allowsHitTesting(false)
                }
            
            Text("Collection")
                .font(.system(size: 20, weight: .semibold, design: .default))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .padding(.top, 10)
            
            LazyVStack(spacing: 30) {
                ForEach(collectionsVM.collections) { collection in
                    AsyncImage(url: URL(string: collection.url)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(20)
                    .padding(.horizontal)
                }
            }
            .padding(.top, 10)
            }
            .coordinateSpace(name: "scroll")
            .onAppear {
            
                collectionsVM.fetchCollections()
            }
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                withAnimation(.easeInOut(duration: 6)) {
                    scrollOffset = value
                }
            }
            .background(Color.black)
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    ZStack {
                        Color.black
                            .opacity(scrollOffset < -300 ? 1 : 0)
                            .animation(.easeInOut(duration: 6), value: scrollOffset)
                            .ignoresSafeArea()

                        Image("backdropify")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130, height: 24)
                    }
                }
            }
        }
        .background(Color.black)
    }
}

#Preview {
    HomeView()
}
