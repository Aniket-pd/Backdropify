import SwiftUI

struct ProfileView: View {
    @State private var username: String = "Aniket  "
    @State private var coins: Int = 233
    @State private var downloadedWallpapers: Int = 43

    var body: some View {
        VStack(spacing: 50) {
            ZStack {
                HStack(spacing: 0) {
                    Text("Hey, ")
                        .font(.custom("SF Pro Display", size: 36).weight(.bold))
                        .foregroundColor(.white.opacity(0.75))

                    Text(username)
                        .font(.custom("SF Pro Display", size: 36).weight(.bold))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 227/255, green: 48/255, blue: 207/255),
                                    Color(red: 86/255, green: 131/255, blue: 228/255)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.top, 70)
            }
            
            Spacer()
            
            // MARK: - Menu Buttons
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.1))
                    .frame(maxWidth: .infinity, maxHeight: 420)
                
                VStack(spacing: 8) {
                    ProfileButton(label: "Purchase History", icon: "clock") {
                        print("purchase History")
                    }
                    ProfileButton(label: "Coin History", icon: "banknote") {
                        print("purchase History")
                    }
                    ProfileButton(label: "My Downloads", icon: "square.and.arrow.down.on.square") {
                        print("my download")
                    }
                    ProfileButton(label: "Switch theme", icon: "circle.lefthalf.filled") {
                        print("Switch theme")
                    }
                    ProfileButton(label: "Help & Support", icon: "questionmark.circle") {
                        print("help & support")
                    }
                    ProfileButton(label: "Logout", icon: "rectangle.portrait.and.arrow.right", isLogout: true) {
                        print("logout")
                    }
                }
            }
            .padding(.horizontal, 16)

            Spacer()

            Text("blackdropify")
                .foregroundColor(.gray.opacity(0.6))
                .italic()
                .padding(.bottom)
        }
        .background(
            Image("ProfileBackground")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
        )
    }
}

// MARK: - Reusable Button
struct ProfileButton: View {
    var label: String
    var icon: String
    var isLogout: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 13) {
                Image(systemName: icon)
                    .foregroundColor(.white.opacity(0.75))
                    .frame(width: 24)
                    
                Text(label)
                    .foregroundColor(.white.opacity(0.75))
                    .font(.system(size: 17, weight: .semibold))

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(Color(red: 114/255, green: 114/255, blue: 114/255, opacity: 1))
                    .padding(.trailing, 16)
                    //.frame(width: 30, height: 30)
            }
            .frame(maxWidth: .infinity, minHeight: 52)
            //.background(Color.gray.opacity(0.15))
            .cornerRadius(12)
            .padding(.leading, 16)
        }
    }
}

#Preview {
    ProfileView()
}
