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
        WindowGroup {
            homeView()
        }
    }
}
