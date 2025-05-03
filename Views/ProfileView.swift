import SwiftUI

struct ProfileView: View {
    @State private var username: String = "Aniket prasad "
    @State private var coins: Int = 233
    @State private var downloadedWallpapers: Int = 43

    var body: some View {
        VStack(spacing: 30) {
            // MARK: - Profile Info
            HStack(alignment: .center, spacing: 16) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 111, height: 110)
                    .clipShape(Circle())
                    .foregroundColor(.gray)

                VStack(alignment: .leading, spacing: 8) {
                    Text(username)
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)

                    HStack(spacing: 10) {
                        Label("\(coins)", systemImage: "bitcoinsign.circle")
                            .foregroundColor(.yellow)
                            .font(.subheadline)

                        Text("\(downloadedWallpapers) wallpapers")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)

            // MARK: - Menu Buttons
            VStack(spacing: 20) {
                ProfileButton(label: "Purchase History", icon: "clock") {
                    print("purchase History")
                }
                ProfileButton(label: "My Downloads", icon: "arrow.down.circle") {
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

            Spacer()

            Text("blackdropify")
                .foregroundColor(.gray.opacity(0.6))
                .italic()
                .padding(.bottom)
        }
        .padding(.top)
        .background(Color.black.ignoresSafeArea())
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
            HStack {
                Image(systemName: icon)
                    .foregroundColor(isLogout ? .red : .white)
                    .frame(width: 24)

                Text(label)
                    .foregroundColor(isLogout ? .red : .white)
                    .font(.system(size: 18, weight: .bold))

                Spacer()
            }
            .padding(.horizontal)
            .frame(width: 328, height: 61)
            .background(Color(.darkGray))
            .cornerRadius(12)
        }
    }
}

#Preview {
    ProfileView()
}

