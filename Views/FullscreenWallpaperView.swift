//
//  FullscreenWallpaperView.swift
//  Backdropify
//
//  Created by Aniket prasad on 19/5/25.
//

import SwiftUI

struct FullscreenWallpaperView: View {
    let wallpaper: Wallpaper
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        ZStack {
            // Top Bar (Back + Coin Info)
            VStack {
                HStack {
                    // Back button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }

                    Spacer()

                    // Coin Display
                    HStack(spacing: 4) {
                        Image(systemName: "bitcoinsign.circle")
                        Text("\(wallpaper.coin)")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .clipShape(Capsule())
                }
                .padding(.horizontal)
                .padding(.top, 40) // For safe area

                Spacer()

                // Bottom Bar Buttons
                HStack(spacing: 40) {
                    Button(action: {
                        print("Info button pressed")
                    }) {
                        VStack {
                            Image(systemName: "info.circle")
                                .font(.title2)
                            Text("Info")
                        }
                    }

                    Button(action: {
                        print("Download button pressed")
                    }) {
                        VStack {
                            Image(systemName: "arrow.down.circle")
                                .font(.title2)
                            Text("Download")
                        }
                    }

                    Button(action: {
                        print("View button pressed")
                    }) {
                        VStack {
                            Image(systemName: "eye.circle")
                                .font(.title2)
                            Text("View")
                        }
                    }
                }
                .foregroundColor(.white)
                .padding(.bottom, 30)
            }
        }
        .background(
            AsyncImage(url: URL(string: wallpaper.url)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                case .failure:
                    Image(systemName: "xmark.octagon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.red)
                @unknown default:
                    EmptyView()
                }
            }
        )
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
    }
}



#Preview {
    let sampleWallpaper = Wallpaper(
        id: "sample",
        name: "Beautiful",
        url: "https://picsum.photos/400/800",
        coin: 15
    )

    return FullscreenWallpaperView(wallpaper: sampleWallpaper)
}
