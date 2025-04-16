//
//  WallpaperViewModel.swift
//  Backdropify
//
//  Created by Aniket prasad on 8/4/25.
//

import Foundation
import FirebaseFirestore

class WallpaperViewModel: ObservableObject {
    @Published var wallpapers: [Wallpaper] = []

    private var db = Firestore.firestore()

    func fetchWallpapers() {
        db.collection("wallpapers").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching wallpapers: \(error)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }

            self.wallpapers = documents.compactMap { doc in
                try? doc.data(as: Wallpaper.self)
            }
        }
    }
}
