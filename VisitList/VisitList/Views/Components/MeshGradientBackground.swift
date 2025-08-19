//
//  MeshGradientBackground.swift
//  VisitList
//
//  Created by Thomas Mani on 26/07/25.
//

import SwiftUI

struct MeshGradientBackground: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var lightColors: [Color] = []
    @State private var darkColors: [Color] = []
    
    private static let lightThemeColours: [Color] = [
        Color(hex: "#FFE066"), // vibrant pastel yellow
        Color(hex: "#FFADAD"), // watermelon pink
        Color(hex: "#FFD6A5"), // peach
        Color(hex: "#FDFFB6"), // soft lemon
        Color(hex: "#CAFFBF"), // pastel green
        Color(hex: "#9BF6FF"), // sky aqua
        Color(hex: "#A0C4FF"), // soft blue
        Color(hex: "#BDB2FF"), // lilac
        Color(hex: "#FFC6FF")  // pink lavender
    ]
    
    private static let darkThemeColours: [Color] = [
        Color(hex: "#0D0C1D"), // deep violet black
        Color(hex: "#1A1A40"), // midnight navy
        Color(hex: "#3C096C"), // royal purple
        Color(hex: "#240046"), // rich indigo
        Color(hex: "#0B132B"), // ink blue
        Color(hex: "#1B2A41"), // cold steel
        Color(hex: "#3A0CA3"), // vivid blue-violet
        Color(hex: "#560BAD"), // electric purple
        Color(hex: "#7209B7")  // magenta-indigo
    ]
    
    @State private var points: [SIMD2<Float>] = [
        [0, 0], [0.5, 0], [1, 0],
        [0, 0.5], [0.5, 0.5], [1, 0.5],
        [0, 1], [0.5, 1], [1, 1]
    ]
    
    var body: some View {
        if #available(iOS 18.0, *) {
            MeshGradient(
                width: 3,
                height: 3,
                points: points,
                colors: colorScheme == .light ? lightColors : darkColors
            )
            .ignoresSafeArea()
            .onAppear {
                lightColors = MeshGradientBackground.lightThemeColours.shuffled()
                darkColors = MeshGradientBackground.darkThemeColours.shuffled()
            }
            .onReceive(Timer.publish(every: 5, on: .main, in: .common).autoconnect()) { _ in
                withAnimation(.easeInOut(duration: 5.0)) {
                    updatePoints()
                }
            }
        } else {
            LinearGradient(
                gradient: Gradient(
                    colors: Array(
                        (colorScheme == .light ? lightColors : darkColors)[0...2]
                    )
                ),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .onAppear {
                lightColors = MeshGradientBackground.lightThemeColours.shuffled()
                darkColors = MeshGradientBackground.darkThemeColours.shuffled()
            }
        }
    }
    
    private func updatePoints() {
        // Randomize the middle point for a smooth fluid effect
        points[4] = [Float.random(in: 0.1...0.9), Float.random(in: 0.1...0.9)]
    }
    
}

#Preview {
    MeshGradientBackground()
}
