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
    @State private var showInfoSheet = false
    var collectionName: String = "Abstract Art" // Example, ideally passed from parent

    var body: some View {
        ZStack {
            // Top Bar (Back + Coin Info)
            VStack {
                HStack {
                    // Back button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.backward")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                        
                            .padding()
                            //.background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }

                    Spacer()

                    // Coin Display
                    HStack(spacing: 6) {
                        Image("Coin")
                            .resizable()
                            .frame(width: 25, height: 19)
                            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                        Text("\(wallpaper.coin)")
                            .font(.system(size: 20))
                            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                    }
                    .foregroundColor(.white)
                    .padding()
                   // .background(Color.black.opacity(0.5))
                    .clipShape(Capsule())
                }
                .padding(.horizontal)
                .padding(.top, 10) // For safe area

                Spacer()

                // Bottom Bar Buttons  3 buttons
                HStack {
                    Spacer()

                    Button(action: {
                        showInfoSheet = true
                    }) {
                        VStack {
                            Image(systemName: "info.circle")
                                .font(.title2)
                            Text("Info")
                        }
                        .frame(maxWidth: .infinity)
                    }

                    Button(action: {
                        print("Download button pressed")
                    }) {
                        VStack {
                            Image(systemName: "arrow.down.circle")
                                .font(.title2)
                            Text("Download")
                        }
                        .frame(maxWidth: .infinity)
                    }

                    Button(action: {
                        print("View button pressed")
                    }) {
                        VStack {
                            Image(systemName: "eye.circle")
                                .font(.title2)
                            Text("View")
                        }
                        .frame(maxWidth: .infinity)
                    }

                    Spacer()
                }
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
        }
        .sheet(isPresented: $showInfoSheet) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.thinMaterial)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    VStack(spacing: 23) {
                        HStack {
                            Image(systemName: "info.circle")
                            Text("Informations")
                                .font(.system(size: 24, weight: .semibold))
                        }
                        .padding(.top, 30)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)

                        Divider()
                            .frame(height: 0.3)
                            .background(Color.gray)
                            .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Image(systemName: "info.circle")
                                Text(collectionName)
                            }
                            .font(.system(size: 16))

                            HStack {
                                Image(systemName: "info.circle")
                                Text(wallpaper.name)
                            }
                            .font(.system(size: 16))

                            HStack {
                                Image("Coin")
                                    .resizable()
                                    .frame(width: 18, height: 14)
                                Text("\(wallpaper.coin) coins")
                            }
                            .font(.system(size: 16))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 44)
                    }
                    .padding(.top, 0)

                    Spacer()
                }
            }
            .presentationDetents([.height(253)])
            //.presentationDragIndicator(.visible)
            .presentationBackground(.ultraThinMaterial)
            .presentationCornerRadius(30)
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
        url: "https://res.cloudinary.com/dxmwaa0nv/image/upload/v1747080151/IMG_5167_d1d6ny.jpg",
        coin: 15
    )

    return FullscreenWallpaperView(wallpaper: sampleWallpaper)
}
