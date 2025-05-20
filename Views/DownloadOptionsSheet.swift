//
//  DownloadOptionsSheet.swift
//  Backdropify
//
//  Created by Aniket prasad on 20/5/25.
//
import SwiftUI

struct DownloadOptionsSheet: View {
    var wallpaperCoins: Int

    var body: some View {
        VStack(spacing: 0) {
            
            // Header Section
            HStack(spacing: 10) {
                Image(systemName: "gearshape")
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Text("Download option")
                    .font(.system(size: 16, weight: .regular))
            }
            .padding(.top, 26)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)

            // Divider
            Divider()
                .frame(height: 0.3)
                .padding(.top, 23)

            // Buttons Section
            VStack(spacing: 26) {
                // HD Download Button
                DownloadOptionButton(
                    icon: "arrow.down.to.line",
                    title: "Download [HD]",
                    coinValue: wallpaperCoins
                )

                // 4K Download Button
                DownloadOptionButton(
                    icon: "arrow.down.to.line",
                    title: "Download [4K]",
                    coinValue: wallpaperCoins
                )

                // Watch Ad Button
                DownloadOptionButton(
                    icon: "play.rectangle",
                    title: "Watch Ad",
                    coinValue: 70,
                    isAd: true
                )
            }
            .padding(.top, 23)
            .padding(.horizontal, 33)

            Spacer()
        }
    }
}

struct DownloadOptionButton: View {
    var icon: String
    var title: String
    var coinValue: Int
    var isAd: Bool = false

    var body: some View {
        HStack {
            // Left Side
            HStack(spacing: 10) {
                Image(systemName: icon)
                Text(title)
                    .font(.system(size: 18, weight: .bold))
            }

            Spacer()

            // Right Side
            HStack(spacing: 4) {
                Image(systemName: isAd ? "plus.circle.fill" : "bitcoinsign.circle.fill")
                    .shadow(radius: 2)
                Text("\(coinValue)")
                    .font(.system(size: 14, weight: .bold))
            }
        }
        .padding(.horizontal, 22)
        .frame(width: 230, height: 54)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
