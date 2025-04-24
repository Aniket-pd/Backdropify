import Foundation
import FirebaseFirestore


class WallpapersByCollectionViewModel: ObservableObject {
    @Published var wallpapers: [Wallpaper] = []

    func fetchWallpapers(from collectionName: String) {
        let db = Firestore.firestore()
        db.collection(collectionName).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching wallpapers: \(error)")
                return
            }

            self.wallpapers = snapshot?.documents.compactMap { doc in
                try? doc.data(as: Wallpaper.self)
            } ?? []
            print("fetched")
        }
    }
}
