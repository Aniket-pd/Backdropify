import SwiftUI

struct HomeView: View {
    
    @State private var currentIndex = 0
    //--------------
    @StateObject private var collectionsVM = WallpaperCollectionsViewModel()
    
    //----------------------
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
                            destination: CollectionDetailView(collection: collection)
                        ) {
                            ZStack(alignment: .bottomLeading) {
                                AsyncImage(url: URL(string: collection.url)) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .contentTransition(.opacity)

                                    case .failure(_):
                                        Color.gray.opacity(0.3)
                                            .cornerRadius(14)

                                    case .empty:
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(Color.gray.opacity(0.3))
                                            .redacted(reason: .placeholder)

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
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                }
                .onAppear {
                
                    collectionsVM.fetchCollections()
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
