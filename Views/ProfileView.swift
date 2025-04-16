//
//  ProfileView.swift
//  Backdropify
//
//  Created by Aniket prasad on 13/4/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack(alignment: .top) { // Use ZStack for layering

                    // Layer 1: The Image (at the bottom)
                    Image("Afuturisticneonlitstreeta_18295513") // <-- Replace with your image asset name
                        .resizable() // Make it resizable
                        .scaledToFill() // Fill the frame, cropping if needed
                        .frame(height: 200) // Set the fixed height
                        .clipped() // Don't draw outside the frame
                        .ignoresSafeArea(.container, edges: .top) // <<< Crucial: Extend under status bar

                    // Layer 2: Simple Text Overlay (on top)
                    Text("Title Over Image")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.top, 60) // <<< Add padding to avoid status bar area
                        .shadow(radius: 3) // Make text readable

                    // You would typically add more content below the ZStack,
                    // potentially wrapping the ZStack in a ScrollView or VStack.
                }
    }
}
#Preview {
    ProfileView()
}
