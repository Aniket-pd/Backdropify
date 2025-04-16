//
//  User.swift
//  Backdropify
//
//  Created by Aniket prasad on 9/4/25.
//


struct User: Identifiable, Codable {
    var id: String
    var coins: Int
    var purchasedWallpaperIDs: [String]
}
