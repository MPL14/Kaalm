//
//  ProfileView.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/26/24.
//

import RevenueCat
import RevenueCatUI
import SwiftUI

struct ProfileView: View {
    // MARK: - Environment
    @EnvironmentObject private var hapticEngine: HapticEngine

    @AppStorage("gridRows") var currentGridRows: Double = 16.0
    @AppStorage("gridCols") var currentGridCols: Double = 16.0
    @AppStorage("dotSize") var currentDotSize: Double = 10.0
    @AppStorage("feedbackIntensity") var feedbackIntensity: Double = 1.0
    @AppStorage("myColor") var myColor: String = ""

    var body: some View {
        List {
            Group {
                Section("Appearance - Premium") {
                    HStack {
                        Text("Grid Rows")
                        Slider(value: $currentGridRows, in: 3...18)
                    }

                    HStack {
                        Text("Grid Columns")
                        Slider(value: $currentGridCols, in: 3...18)
                    }

                    HStack {
                        Text("Dot Size")
                        Slider(value: $currentDotSize, in: 3...20)
                    }

                    HStack {
                        Text("Feedback Intensity")
                        Slider(value: $feedbackIntensity, in: 0...1)
                    }

                    HStack {
                        CustomColorPicker(selectedColor: $myColor)
                            .colors(
                                ["Default", "Clay", "Ocean", "Rose", "Sage"]
                            )
                            .title("Grid Color")
                            .highlightColor(Color("Default"))
                    }
                }
                .onChange(of: feedbackIntensity) { value in
                    hapticEngine.asyncPlayHaptic(intensity: feedbackIntensity, sharpness: feedbackIntensity)
                }
            }
            .tint(Color("Default"))
        }
        .presentPaywallIfNeeded(requiredEntitlementIdentifier: "premium_lifetime")
    }
}

#Preview {
    ProfileView()
}
