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

    @State private var isPremiumUnlocked: Bool = false
    @State private var manuallyShowPaywall: Bool = false

    var body: some View {
        List {
            Group {
                Section("Appearance - Premium") {
                    appearanceControls

                    manuallyPurchasePremiumButton
                }
                .onChange(of: feedbackIntensity) { value in
                    hapticEngine.asyncPlayHaptic(
                        intensity: feedbackIntensity,
                        sharpness: feedbackIntensity
                    )
                }
            }
            .tint(Color("Default"))
        }
        .task {
            self.isPremiumUnlocked = await PurchaseManager.shared.isPremiumUnlocked()
        }
        .presentPaywallIfNeeded(
            requiredEntitlementIdentifier: PurchaseManager.premiumEntitlement,
            purchaseCompleted: { _ in
                self.isPremiumUnlocked = true
            }, restoreCompleted: { _ in
                self.isPremiumUnlocked = true
            })
        .sheet(isPresented: self.$manuallyShowPaywall) {
            PaywallView(displayCloseButton: true)
        }
    }

    // MARK: - Subviews
    private var appearanceControls: some View {
        Group {
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
        .disabled(
            !isPremiumUnlocked
        )
    }

    // This is a fix for putting a Button inside of a List.
    // The Button tap gesture messes with the scrolling gesture
    // of the list and causes conflicts. This is a method for
    // getting a seamless looking button.
    private var manuallyPurchasePremiumButton: some View {
        Button(action: {}) {
            Button(action: {
                self.manuallyShowPaywall = true
            }) {
                Text("Purchase Premium for $0.99")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, minHeight: 44)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.roundedRectangle(radius: 0))
            .tint(.blue)
        }
        .buttonStyle(.plain)
        .listRowBackground(EmptyView())
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

#Preview {
    ProfileView()
}
