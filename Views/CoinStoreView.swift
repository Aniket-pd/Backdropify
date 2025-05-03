import SwiftUI

struct CoinStoreView: View {
    // Example dynamic coin count variable
    @State private var coinCount: Int = 2555

    var body: some View {
        VStack(spacing: 24) {
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
                .frame(width: 329, height: 144)
                .padding(.bottom, 28)
                .overlay(
                    HStack {
                        Image(systemName: "bitcoinsign.circle.fill") // placeholder icon
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.yellow)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 5) {
                            Text("You have")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                            Text("\(coinCount) coins")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(16)
                    .frame(height: 144)
                )

            // Section 2: Get More Coins
            VStack(alignment: .leading, spacing: 12) {
                Text("Get More Coins")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 8)
                    .padding(.leading, 14)

                // 2x2 grid of buttons
                LazyVGrid(columns: [GridItem(.fixed(155)), GridItem(.fixed(155))], spacing: 16) {
                    coinButton(coinAmount: 50, price: 59)
                    coinButton(coinAmount: 100, price: 59)
                    coinButton(coinAmount: 250, price: 59)
                    coinButton(coinAmount: 500, price: 59)
                }
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
                        earnButton(icon: "gift.fill", title: "Watch Ad", reward: "+50 coins")
                        earnButton(icon: "clock.fill", title: "Daily bonus", reward: "+10 coins")
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
                    .foregroundColor(.white)
                Image(systemName: "bitcoinsign.circle.fill")
                    .foregroundColor(.yellow)
                Text("for $\(price)")
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .frame(width: 155, height: 48)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
        }
    }

    // Earn Button
    private func earnButton(icon: String, title: String, reward: String) -> some View {
        Button(action: {
            if title == "Watch Ad" {
                print("ad played")
                coinCount += 50
            } else if title == "Daily bonus" {
                print("video watched")
                coinCount += 10
            }
        }) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.white)
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Text(reward)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .frame(width: 329, height: 48)
            .background(icon == "gift.fill" ? Color.yellow : Color.gray.opacity(0.2))
            .cornerRadius(12)
        }
    }
}

struct CoinStoreView_Previews: PreviewProvider {
    static var previews: some View {
        CoinStoreView()
    }
}
