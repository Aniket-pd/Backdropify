import SwiftUI

struct CoinStoreView: View {
    // Example dynamic coin count variable
    @State private var coinCount: Int = 2555
    @State private var shimmer: CGFloat = -1
    @State private var displayedCoinCount: Int = 0

    var body: some View {
        ZStack(alignment: .top) {
            // Background Image at the top (365pt height)
            Image("IMG_5143")
                .resizable()
                .scaledToFill()
                .frame(height: 310)  // <- change Image height from here
                .clipped()
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.black.opacity(0), Color.black]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 330)
                    .padding(.top, 30)
                )
                .ignoresSafeArea(edges: .top)

            VStack(spacing: 18) { // Section 1 (coin balance)
                VStack(alignment: .center, spacing: 10) {
                    Text("You have")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .kerning(0.5) // distance between charcters
                        //.padding(.leading, 30)

                    GeometryReader { geometry in
                        Text("\(displayedCoinCount) coins")
                            .font(.system(size: 50, weight: .heavy))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.25), radius: 6, x: 1, y: 1)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .frame(maxWidth: geometry.size.width)
                            .onAppear {
                                animateCoinCount(to: coinCount)
                            }
                    }
                    .frame(height: 70)
                    //.padding(.leading, 16)
                }
            }
            .padding(.top, 55) // top padding for coins quote

            VStack(spacing: 18) { // Section 2 and 3 start below image
                // Section 2: Get More Coins
                VStack(alignment: .leading, spacing: 12) {
                    Text("Get More Coins")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.bottom, 8)
                        .padding(.leading, 14)

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
                            earnButton(icon: "gift", iconColor: .black, title: "Watch Ad", reward: "+50 coins", textColor: .black, background: AnyView(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 254/255, green: 0/255, blue: 162/255),
                                        Color(red: 94/255, green: 161/255, blue: 211/255)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            ), cornerRadius: 10) {
                                print("ad played")
                                coinCount += 50
                                animateCoinCount(to: coinCount)
                            }
                            earnButton(icon: "clock", iconColor: .white, title: "Daily bonus", reward: "+10 coins", textColor: .white, background: AnyView(Color.gray.opacity(0.15)), cornerRadius: 10) {
                                print("video watched")
                                coinCount += 10
                                animateCoinCount(to: coinCount)
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.leading, 16)

                Spacer()
            }
            .padding(.top, 250) // push below image height distance between image and section 2 + 3
            .padding()
        }
        .background(Color.black.ignoresSafeArea())
    }

    // Coin Button
    private func coinButton(coinAmount: Int, price: Int) -> some View {
        Button(action: {
            print("added \(coinAmount) coins")
            coinCount += coinAmount
            animateCoinCount(to: coinCount)
        }) {
            HStack {
                
                Image("Coin")
                    .foregroundColor(.yellow)
                Text("\(coinAmount)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    
                Text("for $\(price)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 0)
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(Color.gray.opacity(0.13))
            .cornerRadius(12)
        }
    }

    // Earn Button
    private func earnButton(icon: String, iconColor: Color, title: String, reward: String, textColor: Color, background: AnyView, cornerRadius: CGFloat, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 13) {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .shadow(color: .black.opacity(0.25), radius: 6, x: 1, y: 1)
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(textColor)
                    .shadow(color: .black.opacity(0.25), radius: 6, x: 1, y: 1)
                Spacer()
                Text(reward)
                    .font(.system(size: 16))
                    .foregroundColor(textColor)
                    .shadow(color: .black.opacity(0.25), radius: 6, x: 1, y: 1)
            }
            .padding(.horizontal, 16)
            .frame(width: 329, height: 52)
            .background(background)
            .cornerRadius(cornerRadius)
        }
    }

    private func animateCoinCount(to newCount: Int) {
        shimmer = 1.5
        let startCount = displayedCoinCount
        let duration = 1.0
        let steps = 60
        let stepTime = duration / Double(steps)
        var currentStep = 0
        Timer.scheduledTimer(withTimeInterval: stepTime, repeats: true) { timer in
            currentStep += 1
            let progress = Double(currentStep) / Double(steps)
            displayedCoinCount = Int(Double(startCount) + (Double(newCount - startCount) * progress))
            if currentStep >= steps {
                displayedCoinCount = newCount
                timer.invalidate()
            }
        }
    }
}

struct CoinStoreView_Previews: PreviewProvider {
    static var previews: some View {
        CoinStoreView()
    }
}
