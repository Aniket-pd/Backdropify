import SwiftUI

struct HomeView: View {
    @State private var currentIndex = 0
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    private let imageNames = [
        "Afuturisticneonlitstreeta_18295513",
        
    ]
    
    var body: some View {
        ScrollView {
            TabView(selection: $currentIndex) {
                ForEach(0..<imageNames.count, id: \.self) { index in
                    Image(imageNames[index])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .tag(index)
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.69) // 30% of screen height
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .onReceive(timer) { _ in
                withAnimation {
                    currentIndex = (currentIndex + 1) % imageNames.count
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    HomeView()
}
