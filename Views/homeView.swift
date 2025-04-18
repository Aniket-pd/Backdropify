import SwiftUI

struct HomeView: View {
    @State private var currentIndex = 0
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    private let imageNames = [
        "Afuturisticneonlitstreeta_18295513",
        "Naturescenelandscapeview_88300727",
        "photographyportraitofcontr_64338086 (1)"
        
    ]
    private let collectionImages = [
        "Nature",
        "abstract art",
        "anime"
        
    ]
    
    var body: some View {
        NavigationView {
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
                ForEach(0..<collectionImages.count, id: \.self) { index in
                    Image(collectionImages[index])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(20)
                        .padding(.horizontal)
                }
            }
            .padding(.top, 10)
            
            
            
            }
            .background(Color.black)
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("backdropify")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 130, height: 24) // Adjust size as needed
                }
            }
        }
        .background(Color.black)
    }
}

#Preview {
    HomeView()
}
