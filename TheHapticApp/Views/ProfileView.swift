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

    @AppStorage(Constants.gridRows) var currentGridRows: Double = 16.0
    @AppStorage(Constants.gridCols) var currentGridCols: Double = 16.0
    @AppStorage(Constants.dotSize) var currentDotSize: Double = 10.0
    @AppStorage(Constants.feedbackIntensity) var feedbackIntensity: Double = 1.0
    @AppStorage(Constants.myColor) var myColor: String = Constants.defaultColor

    @State private var isPremiumUnlocked: Bool = false
    @State private var manuallyShowPaywall: Bool = false

    var body: some View {
        List {
            Group {
                Section("Customize") {
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
        }
        .task {
            self.isPremiumUnlocked = await PurchaseManager.shared.isPremiumUnlocked()
        }
        .presentPaywallIfNeeded(
            requiredEntitlementIdentifier: Constants.premiumEntitlement,
            purchaseCompleted: { customerInfo in
                print(customerInfo)
                self.isPremiumUnlocked = true
            }, restoreCompleted: { customerInfo in
                print(customerInfo)
                Task {
                    self.isPremiumUnlocked = await PurchaseManager.shared.isPremiumUnlocked()
                }
            })
        .sheet(isPresented: self.$manuallyShowPaywall) {
            PaywallView(displayCloseButton: true)
        }
        .tint(Color("Default"))
        .navigationTitle("Customize Appearance")
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
                        [Constants.defaultColor, Constants.clayColor, Constants.oceanColor, Constants.roseColor, Constants.sageColor]
                    )
                    .title("Grid Color")
                    .highlightColor(Color(Constants.defaultColor))
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
                if !isPremiumUnlocked {
                    self.manuallyShowPaywall = true
                }
            }) {
                Text(isPremiumUnlocked ? "Premium Enabled" : "Purchase Premium for $0.99")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, minHeight: 30)
                    .foregroundStyle(.blue)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.roundedRectangle(radius: 0))
        }
        .buttonStyle(.plain)
        .listRowBackground(EmptyView())
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        .tint(.blue)
        .allowsHitTesting(!isPremiumUnlocked)
    }
}

#Preview {
    ProfileView()
}
