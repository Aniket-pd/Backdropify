import SwiftUI

struct CoinStoreView: View {
    // Example dynamic coin count variable
    @State private var coinCount: Int = 2555

    var body: some View {
        VStack(spacing: 18) { // adjust padding between each section
            // Top "Coins" title
            HStack {
                Text("Coins")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 16)
                    .padding(.leading, 12)
                Spacer()
            }

            // Section 1: Coin balance box
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.yellow.opacity(0.2)) // dark yellow with low opacity
                .frame(width: 329, height: 100)
                .padding(.bottom, 28)
                .overlay(
                    HStack(alignment: .center) {
                        Image("Bunch coin")
                            .resizable()
                            .frame(width: 55, height: 55)
                            .foregroundColor(.yellow)
                            //.padding(.leading, 0)
                            .padding(.bottom, 20)
                            .padding(.trailing, 50) // adjust distance between icon and text
                            //.border(Color.red)
                        
                        VStack(alignment: .center, spacing: 5) {
                            Text("You have")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                            Text("\(coinCount) coins")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                        }
                        //.border(Color.red)
                        .padding(.bottom, 20)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding(16)
                )

            // Section 2: Get More Coins
            VStack(alignment: .leading, spacing: 12) {
                Text("Get More Coins")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 8)
                    .padding(.leading, 14)

                // 2x2 grid of buttons
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ], spacing: 16) {
                    coinButton(coinAmount: 50, price: 59)
                    coinButton(coinAmount: 100, price: 59)
                    coinButton(coinAmount: 250, price: 59)
                    coinButton(coinAmount: 500, price: 59)
                }
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 28)

            // Section 3: Earn Coins for Free
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Earn coins for free")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.bottom, 8)

                    VStack(spacing: 16) {
                        earnButton(icon: "gift.fill", iconColor: .black, title: "Watch Ad", reward: "+50 coins", textColor: .black,     backgroundColor: Color(red: 1.0, green: 0.76, blue: 0.38, opacity: 1), cornerRadius: 10) {
                            print("ad played")
                            coinCount += 50
                        }
                        earnButton(icon: "clock.fill", iconColor: .white, title: "Daily bonus", reward: "+10 coins", textColor: .white, backgroundColor: .gray.opacity(0.15), cornerRadius: 10) {
                            print("video watched")
                            coinCount += 10
                        }
                    }
                }
                Spacer()
            }
            .padding(.leading, 16)

            Spacer()
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
    }

    // Coin Button
    private func coinButton(coinAmount: Int, price: Int) -> some View {
        Button(action: {
            print("added \(coinAmount) coins")
            coinCount += coinAmount
        }) {
            HStack {
                Text("\(coinAmount)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Image(systemName: "bitcoinsign.circle.fill")
                    .foregroundColor(.yellow)
                Text("for $\(price)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 0)
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(Color.gray.opacity(0.13))
            .cornerRadius(12)
        }
    }

    // Earn Button
    private func earnButton(icon: String, iconColor: Color, title: String, reward: String, textColor: Color, backgroundColor: Color, cornerRadius: CGFloat, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(textColor)
                Spacer()
                Text(reward)
                    .font(.system(size: 16))
                    .foregroundColor(textColor)
            }
            .padding(.horizontal, 16)
            .frame(width: 329, height: 48)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
        }
    }
}

struct CoinStoreView_Previews: PreviewProvider {
    static var previews: some View {
        CoinStoreView()
    }
}
