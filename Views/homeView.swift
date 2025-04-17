import SwiftUI

struct HomeView: View {
    @State private var currentIndex = 0
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    private let imageNames = [
        "Afuturisticneonlitstreeta_18295513",
        "Asmoothverticalgradientwit_6700173",
        "photographyportraitofcontr_64338086 (1)"
        
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
            .modifier(StretchyHeaderViewModifier(startingHeight: UIScreen.main.bounds.height * 0.69))
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .onReceive(timer) { _ in
                withAnimation {
                    currentIndex = (currentIndex + 1) % imageNames.count
                }
            }
            ZStack {
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(1)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .opacity(0.9)
                    )
                    .frame(height: UIScreen.main.bounds.height * 0.25)
                    .offset(y: -UIScreen.main.bounds.height * 0.25)
                    .allowsHitTesting(false)
                
            }
            
                
            
        }
        .ignoresSafeArea()
    }
}

#Preview {
    HomeView()
        .background(Color.black)
}
