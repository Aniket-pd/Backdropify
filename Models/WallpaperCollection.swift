//
//  WallpaperCollection.swift
//  Backdropify
//
//  Created by Aniket prasad on 23/4/25.
//
import Foundation

struct WallpaperCollection: Identifiable {
    var id: String?            // Firestore document ID
    var name: String            // Display name (e.g., "Nature")
    var url: String    // Thumbnail image URL
}
