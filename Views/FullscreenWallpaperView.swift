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
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let sheetCornerRadius: CGFloat = 24
    private let controlSize: CGFloat = 44
    private let heroThumbnailSize = CGSize(width: 166, height: 220)

    var body: some View {
        ZStack {
            wallpaperBackground
        }
        .ignoresSafeArea()
        .overlay(alignment: .topLeading) {
            closeButton
        }
        .safeAreaInset(edge: .bottom) {
            bottomControls
        }
        .sheet(isPresented: $showInfoSheet) {
            infoSheet
        }
        .sheet(isPresented: $showDownloadSheet) {
            downloadSheet
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
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
        GeometryReader { proxy in
            OptimizedWallpaperImage(
                urlString: wallpaper.url,
                targetSize: proxy.size,
                placeholderSize: heroThumbnailSize,
                contentMode: .fill
            ) {
                Color.black
                    .overlay {
                        ProgressView()
                            .tint(.white)
                    }
            } failure: {
                ZStack {
                    Color.black
                    Image(systemName: "xmark.octagon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.red)
                }
            }
        }
        .contentShape(Rectangle())
    }

    private var closeButton: some View {
        Button(action: dismiss.callAsFunction) {
            Image(systemName: "xmark")
                .font(.system(size: 16, weight: .semibold))
                .frame(width: controlSize, height: controlSize)
                .foregroundStyle(.white)
                .liquidGlassSurface(
                    interactive: true,
                    shape: RoundedRectangle(cornerRadius: 16, style: .continuous)
                )
        }
        .buttonStyle(.plain)
        .padding(.leading, 20)
        .padding(.top, 14)
        .accessibilityLabel("Close wallpaper")
    }

    private var bottomControls: some View {
        HStack(spacing: 14) {
            controlButton(
                systemName: "info.circle",
                label: "Wallpaper information",
                action: { showInfoSheet = true }
            )

            controlButton(
                systemName: "arrow.down.circle",
                label: "Download wallpaper",
                action: { showDownloadSheet = true }
            )

            controlButton(
                systemName: "eye.circle",
                label: "Preview wallpaper",
                action: { print("View button pressed") }
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .frame(maxWidth: .infinity)
        .background(alignment: .bottom) {
            LinearGradient(
                colors: [Color.black.opacity(0), Color.black.opacity(reduceMotion ? 0.55 : 0.72)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }

    private func controlButton(systemName: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 22, weight: .medium))
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .foregroundStyle(.white)
                .liquidGlassSurface(
                    interactive: true,
                    shape: RoundedRectangle(cornerRadius: 18, style: .continuous)
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
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
