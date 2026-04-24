//
//  BackdropifyApp.swift
//  Backdropify
//
//  Created by Aniket prasad on 5/4/25.
//

import SwiftUI
import FirebaseCore
@main
struct BackdropifyApp: App {
    private let useStarterScaffold = ProcessInfo.processInfo.environment["BACKDROPIFY_STARTER"] == "1"
    private let useLiquidGlassDemo = ProcessInfo.processInfo.environment["BACKDROPIFY_LIQUID_GLASS_DEMO"] == "1"

    init(){
        FirebaseApp.configure()
        
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        appearance.backgroundColor = UIColor.black.withAlphaComponent(0.75)

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup{
            if useLiquidGlassDemo {
                NavigationStack {
                    FullscreenWallpaperView(
                        wallpaper: Wallpaper(
                            id: "liquid-glass-demo",
                            name: "Liquid Glass Demo",
                            url: "https://res.cloudinary.com/dxmwaa0nv/image/upload/v1747080151/IMG_5167_d1d6ny.jpg",
                            coin: 20
                        )
                    )
                }
            } else if useStarterScaffold {
                StarterAppView()
            } else {
                CustomTabView()
            }
        }
    }
}

struct CustomTabView: View {
    @State private var selectedTab = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                if selectedTab == 0 {
                    HomeView()
                        .transition(.opacity)
                } else if selectedTab == 1 {
                    FavoritesView()
                        .transition(.opacity)
                } else if selectedTab == 2 {
                    CoinStoreView()
                        .transition(.opacity)
                } else if selectedTab == 3 {
                    ProfileView()
                        .transition(.opacity)
                }
            }
            .animation(reduceMotion ? nil : .easeInOut(duration: 0.2), value: selectedTab)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                ZStack {
                    Color.clear.background(.ultraThinMaterial)
                    Color.black.opacity(0.75)
                }
                .ignoresSafeArea()
            )

            VStack(spacing: 0) {
                Spacer()
                HStack {
                    Spacer()
                    tabBarItem(icon: "house", index: 0)
                    Spacer()
                    tabBarItem(icon: "heart", index: 1)
                    Spacer()
                    tabBarItem(icon: "creditcard", index: 2)
                    Spacer()
                    tabBarItem(icon: "person.crop.circle", index: 3)
                    Spacer()
                }
                .padding(.vertical, 25)
                .background(
                    ZStack {
                        Color.clear.background(.ultraThinMaterial)
                        Color.black.opacity(0.75)
                    }
                )
                .shadow(color: Color.black.opacity(0.4), radius: 10, x: 0, y: -4)
                .foregroundColor(.white)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }

    private func tabBarItem(icon: String, index: Int) -> some View {
        Button(action: {
            selectedTab = index
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }) {
            Image(systemName: icon)
                .font(.system(size: 23, weight: .regular))
                .foregroundColor(selectedTab == index ? .white : .gray)
                .offset(y: -12)
        }
    }
}

struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: blurStyle)
    }
}

#Preview {
    CustomTabView()
}
