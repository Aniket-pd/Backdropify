//
//  WallpaperCollectionsViewModel.swift
//  Backdropify
//
//  Created by Aniket prasad on 23/4/25.
//
import Foundation
import FirebaseFirestore

class WallpaperCollectionsViewModel: ObservableObject {
    @Published var collections: [WallpaperCollection] = []

    func fetchCollections() {
        let db = Firestore.firestore()
        print("something")
        db.collection("collections").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }

            self.collections = documents.compactMap { doc in
                let data = doc.data()
                return WallpaperCollection(
                    id: doc.documentID,
                    name: data["name"] as? String ?? "Unnamed",
                    url: data["url"] as? String ?? ""
                )
            }
        }
    }
}
