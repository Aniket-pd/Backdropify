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
    }
    
    var body: some Scene {
        WindowGroup{
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
        }
    }
}
