//
//  UiWallpaperViewModel.swift
//  Backdropify
//
//  Created by Aniket prasad on 19/4/25.
//

import Foundation
import FirebaseFirestore

class UIWallpaperViewModel: ObservableObject {
    @Published var wallpapers: [UIWallpaper] = []
    
    private var db = Firestore.firestore()
    
    func fetchUIWallpapers() {
        db.collection("ui_wallpapers").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching UI wallpapers: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No UI wallpapers found")
                return
            }
            
            self.wallpapers = documents.compactMap { doc in
                try? doc.data(as: UIWallpaper.self)
            }
        }
    }
}
