//
//  ContentView.swift
//  Backdropify
//
//  Created by Aniket prasad on 5/4/25.
//

import SwiftUI


import SwiftUI

struct homeView: View {
    @StateObject private var viewModel = WallpaperViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Text("Wallpapers")
                    .font(.largeTitle)

                if viewModel.wallpapers.isEmpty {
                    Text("No wallpapers found.")
                        .foregroundColor(.gray)
                } else {
                    List(viewModel.wallpapers) { wallpaper in
                        HStack(alignment: .top) {
                            AsyncImage(url: URL(string: wallpaper.url)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipped()
                            } placeholder: {
                                ProgressView() // shows loading spinner while image loads
                            }

                            VStack(alignment: .leading) {
                                Text(wallpaper.name)
                                    .font(.headline)
                                Text("$\(wallpaper.price, specifier: "%.2f")")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .onAppear {
                viewModel.fetchWallpapers()
            }
        }
    }
}
#Preview {
    homeView()
}
