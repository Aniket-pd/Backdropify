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
                        .font(.system(size: 36, weight: .bold, design: .default))

                    Text(username)
                        .font(.system(size: 36, weight: .bold, design: .default))
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
                VStack(spacing: 4) {
                    ProfileButton(label: "Purchase History", icon: "clock") {
                        print("purchase History")
                    }
                    Divider().frame(height: 0.25).background(Color(red: 68/255, green: 68/255, blue: 68/255))
                    ProfileButton(label: "Coin History", icon: "banknote") {
                        print("purchase History")
                    }
                    Divider().frame(height: 0.25).background(Color(red: 68/255, green: 68/255, blue: 68/255))
                    ProfileButton(label: "My Downloads", icon: "square.and.arrow.down.on.square") {
                        print("my download")
                    }
                    Divider().frame(height: 0.25).background(Color(red: 68/255, green: 68/255, blue: 68/255))
                    ProfileButton(label: "Switch theme", icon: "circle.lefthalf.filled") {
                        print("Switch theme")
                    }
                    Divider().frame(height: 0.25).background(Color(red: 68/255, green: 68/255, blue: 68/255))
                    ProfileButton(label: "Help & Support", icon: "questionmark.circle") {
                        print("help & support")
                    }
                    Divider().frame(height: 0.25).background(Color(red: 68/255, green: 68/255, blue: 68/255))
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
