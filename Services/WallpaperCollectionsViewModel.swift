//
//  WallpaperCollectionsViewModel.swift
//  Backdropify
//
//  Created by Aniket Prasad on 23/4/25.
//

import Foundation
import FirebaseFirestore

class WallpaperCollectionsViewModel: ObservableObject {
    @Published var collections: [WallpaperCollection] = []
    private var hasFetched = false  // ✅ Added to track if data already fetched

    func fetchCollections() {
        guard !hasFetched else { return } // ✅ Skip fetching if already fetched
        
        let db = Firestore.firestore()
        print("Fetching collections from Firestore...") // 🔵 Better log message

        db.collection("collections").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching collections: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents found.")
                return
            }

            self.collections = documents.compactMap { doc in
                let data = doc.data()
                return WallpaperCollection(
                    id: doc.documentID,
                    name: data["name"] as? String ?? "Unnamed",
                    url: data["url"] as? String ?? ""
                )
            }
            
            self.hasFetched = true // ✅ Mark that fetch is done
        }
    }
}
