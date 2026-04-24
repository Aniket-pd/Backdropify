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
                RootTabView()
            }
        }
    }
}

struct RootTabView: View {
    @State private var selectedTab: AppTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house", value: .home) {
                HomeView()
            }

            Tab("Favorites", systemImage: "heart", value: .favorites) {
                FavoritesView()
            }

            Tab("Coin Store", systemImage: "creditcard", value: .coins) {
                CoinStoreView()
            }

            Tab("Profile", systemImage: "person.crop.circle", value: .profile) {
                ProfileView()
            }
        }
        .tabViewStyle(.tabBarOnly)
        .toolbarBackground(.black, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarColorScheme(.dark, for: .tabBar)
        .tint(.white)
        .background(Color.black.ignoresSafeArea())
    }
}

private enum AppTab: Hashable {
    case home
    case favorites
    case coins
    case profile
}

#Preview {
    RootTabView()
}
