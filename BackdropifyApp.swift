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
            ZStack {
                ZStack {
                    Color.clear.background(.ultraThinMaterial)
                    Color.black.opacity(0.75)
                }
                .ignoresSafeArea()

                TabView {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house")
                        }

                    FavoritesView()
                        .tabItem {
                            Image(systemName: "heart")
                        }

                    CoinStoreView()
                        .tabItem {
                            Image(systemName: "creditcard")
                        }

                    ProfileView()
                        .tabItem {
                            Image(systemName: "person.crop.circle")
                        }
                }
                .tint(.white)
            }
            
        }
    }
}

#Preview {
    TabView {
        HomeView()
            .tabItem {
                Image(systemName: "house")
            }

        FavoritesView()
            .tabItem {
                Image(systemName: "heart")
            }

        CoinStoreView()
            .tabItem {
                Image(systemName: "creditcard")
            }

        ProfileView()
            .tabItem {
                Image(systemName: "person.crop.circle")
            }
    }
    
    .background(
        ZStack {
            Color.clear.background(.ultraThinMaterial)
            Color.black.opacity(0.75)
        }
    )
    .tint(.white)
}
