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
        GeometryReader { geometry in
            ZStack {
                // Fullscreen wallpaper image
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

                // Transparent top navigation bar
                VStack {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.black.opacity(0.4))
                                .clipShape(Circle())
                        }

                        Spacer()

                        HStack(spacing: 4) {
                            Image(systemName: "bitcoinsign.circle")
                                .foregroundColor(.white)
                            Text("\(wallpaper.coin)")
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.4))
                        .clipShape(Capsule())
                    }
                    .padding(.top, 50)
                    .padding(.horizontal)

                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .ignoresSafeArea()

                // Transparent tab view with three buttons
                VStack {
                    Spacer()
                    HStack(spacing: 40) {
                        Button(action: {
                            print("Information button pressed")
                        }) {
                            VStack {
                                Image(systemName: "info.circle")
                                    .font(.title2)
                                Text("Info")
                                    .font(.caption)
                            }
                            .foregroundColor(.white)
                        }

                        Button(action: {
                            print("Download button pressed")
                        }) {
                            VStack {
                                Image(systemName: "arrow.down.circle")
                                    .font(.title2)
                                Text("Download")
                                    .font(.caption)
                            }
                            .foregroundColor(.white)
                        }

                        Button(action: {
                            print("iPhone Preview button pressed")
                        }) {
                            VStack {
                                Image(systemName: "iphone")
                                    .font(.title2)
                                Text("Preview")
                                    .font(.caption)
                            }
                            .foregroundColor(.white)
                        }
                    }
                    .frame(width: geometry.size.width)
                    .padding()
                    .background(Color.black.opacity(0.4))
                   // .clipShape(Capsule())
                    .padding(.bottom, -100)
                                    }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .ignoresSafeArea()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }
}



    #Preview {
        WallpaperPreviewView(wallpaper: Wallpaper(id: "1", name: "Sample Wallpaper", url: "https://res.cloudinary.com/dxmwaa0nv/image/upload/v1746215697/IMG_5081_w5tbvj.jpg", coin: 10))
    }
