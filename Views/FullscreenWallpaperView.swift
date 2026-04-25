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
    let isPrimary: Bool
    let action: () -> Void
}

struct FullscreenWallpaperView: View {
    let wallpaper: Wallpaper
    @Environment(\.dismiss) private var dismiss
    @State private var showInfoSheet = false
    var collectionName: String = "Abstract Art"
    @State private var showDownloadSheet = false

    private let sheetCornerRadius: CGFloat = 24

    var body: some View {
        ZStack {
            wallpaperBackground

            VStack {
                topBar
                    .padding(.horizontal)
                    .padding(.top, 10)

                Spacer()

                bottomActionBar
                    .padding(.horizontal)
                    .padding(.bottom, 10)
            }
        }
        .sheet(isPresented: $showInfoSheet) {
            infoSheet
        }
        .sheet(isPresented: $showDownloadSheet) {
            downloadSheet
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
    }

    private var topBar: some View {
        Group {
            if #available(iOS 26, *) {
                GlassEffectContainer(spacing: 24) {
                    topBarContent
                }
            } else {
                topBarContent
            }
        }
    }

    private var topBarContent: some View {
        HStack {
            dismissButton

            Spacer()
        }
    }

    private var dismissButton: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "arrow.backward")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 46, height: 46)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
        }
        .liquidGlassButton(prominent: false)
    }

    private var bottomActionBar: some View {
        Group {
            if #available(iOS 26, *) {
                GlassEffectContainer(spacing: 14) {
                    bottomActionBarContent
                }
            } else {
                bottomActionBarContent
            }
        }
    }

    private var bottomActionBarContent: some View {
        HStack(spacing: 12) {
            flowActionButton(title: "Info", iconName: "info.circle", prominent: false) {
                showInfoSheet = true
            }

            flowActionButton(title: "Download", iconName: "arrow.down.circle", prominent: true) {
                showDownloadSheet = true
            }

            flowActionButton(title: "View", iconName: "eye.circle", prominent: false) {
                print("View button pressed")
            }
        }
    }

    private func flowActionButton(title: String, iconName: String, prominent: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 5) {
                Image(systemName: iconName)
                    .font(.title3)
                Text(title)
                    .font(.subheadline.weight(.semibold))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .foregroundColor(.white)
        }
        .liquidGlassButton(prominent: prominent)
    }

    private var infoSheet: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        Image(systemName: "info.circle")
                        Text("Informations")
                            .font(.system(size: 24, weight: .semibold))
                    }
                    .padding(.top, 30)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)

                    Divider()
                        .overlay(Color.gray.opacity(0.3))

                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Image(systemName: "info.circle")
                            Text(collectionName)
                        }

                        HStack {
                            Image(systemName: "photo")
                            Text(wallpaper.name)
                        }
                    }
                    .font(.system(size: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 44)
                    .padding(.bottom, 30)
                }

                Spacer(minLength: 0)
            }
            .sheetCardSurface(cornerRadius: sheetCornerRadius)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
        .presentationDetents([.height(253)])
        .presentationBackground(sheetPresentationBackground)
        .presentationCornerRadius(30)
    }

    private var downloadSheet: some View {
        let downloadOptions: [DownloadOption] = [
            DownloadOption(title: "Download [HD]", iconName: "arrow.down.to.line", isPrimary: false, action: {
                print("Download HD button pressed")
            }),
            DownloadOption(title: "Download [4K]", iconName: "arrow.down.to.line", isPrimary: false, action: {
                print("Download 4K button pressed")
            })
        ]

        return ZStack {
            VStack(spacing: 0) {
                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        Image(systemName: "gearshape")
                            .font(.system(size: 24))
                        Text("Download option")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .padding(.top, 26)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)

                    Divider()
                        .overlay(Color.gray.opacity(0.3))

                    Group {
                        if #available(iOS 26, *) {
                            GlassEffectContainer(spacing: 14) {
                                downloadOptionsList(downloadOptions: downloadOptions)
                            }
                        } else {
                            downloadOptionsList(downloadOptions: downloadOptions)
                        }
                    }
                    .padding(.top, 8)
                    .padding(.horizontal, 2)
                }

                Spacer(minLength: 0)
            }
            .sheetCardSurface(cornerRadius: sheetCornerRadius)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
        .presentationDetents([.height(360)])
        .presentationBackground(sheetPresentationBackground)
        .presentationCornerRadius(30)
    }

    private var wallpaperBackground: some View {
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
    }

    private func downloadOptionsList(downloadOptions: [DownloadOption]) -> some View {
        VStack(spacing: 14) {
            ForEach(downloadOptions.indices, id: \.self) { index in
                let option = downloadOptions[index]

                Button(action: option.action) {
                    HStack {
                        HStack(spacing: 12) {
                            Image(systemName: option.iconName)
                                .font(.system(size: 20))
                            Text(option.title)
                                .font(.system(size: 18, weight: .bold))
                        }
                    }
                    .padding(.horizontal, 22)
                    .frame(height: 54)
                }
                .downloadOptionStyle(isPrimary: option.isPrimary)
            }
        }
    }

    private var sheetPresentationBackground: AnyShapeStyle {
        if #available(iOS 26, *) {
            return AnyShapeStyle(.clear)
        } else {
            return AnyShapeStyle(.ultraThinMaterial)
        }
    }
}

private extension View {
    @ViewBuilder
    func liquidGlassSurface<S: InsettableShape>(interactive: Bool, shape: S) -> some View {
        if #available(iOS 26, *) {
            if interactive {
                self.glassEffect(.regular.interactive(), in: shape)
            } else {
                self.glassEffect(.regular, in: shape)
            }
        } else {
            self.background(.ultraThinMaterial, in: shape)
        }
    }

    @ViewBuilder
    func liquidGlassButton(prominent: Bool) -> some View {
        if #available(iOS 26, *) {
            if prominent {
                self.buttonStyle(.glassProminent)
            } else {
                self.buttonStyle(.glass)
            }
        } else {
            self.background(Color.black.opacity(0.35), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }

    @ViewBuilder
    func sheetCardSurface(cornerRadius: CGFloat) -> some View {
        if #available(iOS 26, *) {
            self
                .padding(.bottom, 8)
                .glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
        } else {
            self
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        }
    }

    @ViewBuilder
    func downloadOptionStyle(isPrimary: Bool) -> some View {
        if #available(iOS 26, *) {
            if isPrimary {
                self.buttonStyle(.glassProminent)
            } else {
                self.buttonStyle(.glass)
            }
        } else {
            self
                .frame(maxWidth: .infinity)
                .background(
                    isPrimary ?
                    Color(red: 255 / 255, green: 194 / 255, blue: 98 / 255) :
                    Color.white,
                    in: RoundedRectangle(cornerRadius: 10, style: .continuous)
                )
                .foregroundColor(.black)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
    }
}

#Preview {
    let sampleWallpaper = Wallpaper(
        id: "sample",
        name: "Beautiful",
        url: "https://res.cloudinary.com/dxmwaa0nv/image/upload/v1747080151/IMG_5167_d1d6ny.jpg"
    )

    return FullscreenWallpaperView(wallpaper: sampleWallpaper)
}
