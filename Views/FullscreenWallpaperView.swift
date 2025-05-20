//
//  FullscreenWallpaperView.swift
//  Backdropify
//
//  Created by Aniket prasad on 19/5/25.
//

import SwiftUI

struct DownloadOption {
    let title: String
    let iconName: String
    let coinAmount: Int
    let showPlus: Bool
    let action: () -> Void
}

struct FullscreenWallpaperView: View {
    let wallpaper: Wallpaper
    @Environment(\.presentationMode) private var presentationMode
    @State private var showInfoSheet = false
    var collectionName: String = "Abstract Art" // Example, ideally passed from parent
    @State private var showDownloadSheet = false

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
                        showDownloadSheet = true
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
        .sheet(isPresented: $showDownloadSheet) {
            let downloadOptions: [DownloadOption] = [
                DownloadOption(title: "Download [HD]", iconName: "arrow.down.to.line", coinAmount: wallpaper.coin, showPlus: false, action: {
                    print("Download HD button pressed")
                }),
                DownloadOption(title: "Download [4K]", iconName: "arrow.down.to.line", coinAmount: wallpaper.coin, showPlus: false, action: {
                    print("Download 4K button pressed")
                }),
                DownloadOption(title: "Watch Ad", iconName: "play.rectangle", coinAmount: 70, showPlus: true, action: {
                    print("Watch Ad button pressed")
                })
            ]

            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.thinMaterial)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    VStack(spacing: 23) {
                        HStack(spacing: 8) {
                            Image(systemName: "gearshape")
                                .font(.system(size: 24))
                            Text("Download option")
                                .font(.system(size: 16))
                                .bold()
                        }
                        .padding(.top, 26)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)

                        Divider()
                            .frame(height: 0.3)
                            .background(Color.gray)

                        VStack(spacing: 26) { // spacing between buttons
                            ForEach(downloadOptions.indices, id: \.self) { index in
                                let option = downloadOptions[index]
                                HStack {
                                    HStack(spacing: 12) {
                                        Image(systemName: option.iconName)
                                            .font(.system(size: 20))
                                        Text(option.title)
                                            .font(.system(size: 18, weight: .bold))
                                    }

                                    Spacer()

                                    HStack(spacing: 6) {
                                        if option.showPlus {
                                            Text("+")
                                                .font(.system(size: 14, weight: .bold))
                                        }
                                        Image("Coin")
                                            .resizable()
                                            .renderingMode(.template)
                                            .foregroundColor(.black)
                                            .frame(width: 18, height: 14)
                                        Text("\(option.coinAmount)")
                                            .font(.system(size: 14, weight: .bold))
                                    }
                                }
                                .padding(.horizontal, 22)
                                .frame(width: 330, height: 54)
                                .background(
                                    option.title == "Watch Ad" ?
                                        Color(red: 255/255, green: 194/255, blue: 98/255) :
                                        Color.white
                                )
                                .foregroundColor(.black)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                                .onTapGesture {
                                    option.action()
                                }
                            }
                        }
                        .padding(.top, 8)
                    }

                    Spacer()
                }
                .padding(.horizontal, 33)
            }
            .presentationDetents([.height(360)])
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
