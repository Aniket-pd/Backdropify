import SwiftUI

struct HomeView: View {
    var body: some View {
        
        ScrollView{
            ZStack{
                Rectangle()
                    .fill(Color.red)
                    .frame(height: 586)
                    .ignoresSafeArea(.all)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    HomeView()
    
        
}
