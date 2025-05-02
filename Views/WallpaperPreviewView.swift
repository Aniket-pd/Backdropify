//
//  WallpaperPreviewView.swift
//  Backdropify
//
//  Created by Aniket prasad on 3/5/25.
//

import SwiftUI

struct WallpaperPreviewView: View {
    let wallpaper: Wallpaper
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            // 1. Display the wallpaper full screen
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
                    Color.gray
                @unknown default:
                    EmptyView()
                }
            }

            // 2. Top bar: Back button + Coin price
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }

                    Spacer()

                    Text("\(wallpaper.coin) 🪙")
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Capsule())
                }
                .padding(.top, 50) // Adjust as per notch safe area
                .padding(.horizontal)

                Spacer()
            }

            VStack {
                Spacer()
                HStack(spacing: 40) {
                    Button(action: {
                        print("Info button tapped")
                    }) {
                        Image(systemName: "info.circle")
                            .font(.title)
                            .foregroundColor(.white)
                    }

                    Button(action: {
                        print("Download button tapped")
                    }) {
                        Image(systemName: "arrow.down.circle")
                            .font(.title)
                            .foregroundColor(.white)
                    }

                    Button(action: {
                        print("Preview button tapped")
                    }) {
                        Image(systemName: "eye")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color.black.opacity(0.5))
                .clipShape(Capsule())
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true) // hides default nav bar
        .toolbar(.hidden, for: .tabBar)
    }
}
