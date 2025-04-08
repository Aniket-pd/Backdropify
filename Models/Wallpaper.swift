//
//  wallpaper.swift
//  Backdropify
//
//  Created by Aniket prasad on 8/4/25.
//

/*
 Explanation:
 •    Identifiable is a Swift protocol that tells SwiftUI that each wallpaper has a unique id. This is used in lists.
 •    Codable means the structure can convert itself to and from formats (like JSON), which is how data will come from    Firestore.
 •    Each property (id, name, url, price, category, likes) matches the fields you’ll create in Firestore.
 */
import Foundation

struct Wallpaper: Identifiable, Codable {
    var id: String
    var name: String
    var url: String
    var price: Double
    var category: String
    var likes: Int
}
