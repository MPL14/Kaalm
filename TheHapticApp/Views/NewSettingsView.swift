//
//  SettingsView.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/30/24.
//

import MessageUI
import RevenueCat
import RevenueCatUI
import StoreKit
import SwiftUI

struct NewSettingsView: View {
    // MARK: - Environment
    @EnvironmentObject private var hapticEngine: HapticEngine
    @Environment(\.requestReview) var requestReview
    @Environment(\.openURL) var openURL

    @AppStorage(Constants.gridRows) var currentGridRows: Double = 16.0
    @AppStorage(Constants.gridCols) var currentGridCols: Double = 16.0
    @AppStorage(Constants.dotSize) var currentDotSize: Double = 10.0
    @AppStorage(Constants.feedbackIntensity) var feedbackIntensity: Double = 1.0
    @AppStorage(Constants.myColor) var myColor: String = Constants.defaultColor

    // MARK: - State
    @ObservedObject private var viewModel: SettingsViewModel
    @State private var isPremiumUnlocked: Bool = false
    @State private var manuallyShowPaywall: Bool = false

    init(_ viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List {
            Section("General") {
                aboutButton

                requestReviewButton
            }

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

            Section {
                supportEmailButton

                supportWebsiteButton

                privacyPolicyButton

                restorePurchasesButton
            } header: {
                Text("Support")
            } footer: {
                Text(viewModel.appVersionNumber)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 15)
                    .foregroundStyle(.secondary)
            }
        }
        .tint(Color("Default"))
        .navigationTitle("Settings")
        .task {
            self.isPremiumUnlocked = await PurchaseManager.shared.isPremiumUnlocked()
        }
        .sheet(isPresented: self.$manuallyShowPaywall) {
            PaywallView(displayCloseButton: true)
                .onPurchaseCompleted({ customerInfo in
                    print(customerInfo)
                    self.isPremiumUnlocked = true
                })
                .onRestoreCompleted { customerInfo in
                    print(customerInfo)
                    Task {
                        self.isPremiumUnlocked = await PurchaseManager.shared.isPremiumUnlocked()
                    }
                }
        }
        .sheet(isPresented: $viewModel.isShowingMailView) {
            MailView(result: $viewModel.mailResult)
        }
        .alert(viewModel.alertMessageTitle,
               isPresented: $viewModel.showingAlert) { } message: {
            Text(viewModel.alertMessage)
        }
    }

    // MARK: - Subviews
    private var aboutButton: some View {
        NavigationLink {
            VStack {
                Text("About")
            }
        } label: {
            Text("About")
        }
    }

    private var requestReviewButton: some View {
        Button(action: {}) {
            Button {
                Task(priority: .userInitiated) {
                    requestReview()
                }
            } label: {
                Text("Rate The Haptic App")
                    .frame(maxWidth: .infinity, minHeight: 30, alignment: .leading)
                    .foregroundStyle(.blue)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.roundedRectangle(radius: 0))
        }
        .buttonStyle(.plain)
        .listRowInsets(.init(top: 0, leading: 5, bottom: 0, trailing: 0))
        .tint(.clear)
    }

    private var supportEmailButton: some View {
        Button(action: {}) {
            Button {
                viewModel.supportEmailButtonTapped()
            } label: {
                Text(viewModel.supportEmailButtonText)
                    .frame(maxWidth: .infinity, minHeight: 30, alignment: .leading)
                    .foregroundStyle(.blue)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.roundedRectangle(radius: 0))
        }
        .buttonStyle(.plain)
        .listRowInsets(.init(top: 0, leading: 5, bottom: 0, trailing: 0))
        .tint(.clear)
    }

    private var supportWebsiteButton: some View {
        Button(action: {}) {
            Button {
                guard let url = Constants.appSupportPageURL else { return }
                openURL(url)
            } label: {
                Text(viewModel.supportWebsiteButtonText)
                    .frame(maxWidth: .infinity, minHeight: 30, alignment: .leading)
                    .foregroundStyle(.blue)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.roundedRectangle(radius: 0))
        }
        .buttonStyle(.plain)
        .listRowInsets(.init(top: 0, leading: 5, bottom: 0, trailing: 0))
        .tint(.clear)
    }

    private var privacyPolicyButton: some View {
        Button(action: {}) {
            Button {
                guard let url = Constants.appPrivacyPolicyURL else { return }
                openURL(url)
            } label: {
                Text(viewModel.privacyPolicyWebsiteButtonText)
                    .frame(maxWidth: .infinity, minHeight: 30, alignment: .leading)
                    .foregroundStyle(.blue)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.roundedRectangle(radius: 0))
        }
        .buttonStyle(.plain)
        .listRowInsets(.init(top: 0, leading: 5, bottom: 0, trailing: 0))
        .tint(.clear)
    }

    private var restorePurchasesButton: some View {
        Button(action: {}) {
            Button {
                Task(priority: .userInitiated) {
                    await viewModel.restorePurchasesButtonTapped()
                }
            } label: {
                Text(viewModel.restorePurchasesButtonText)
                    .frame(maxWidth: .infinity, minHeight: 30, alignment: .leading)
                    .foregroundStyle(.blue)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.roundedRectangle(radius: 0))
        }
        .buttonStyle(.plain)
        .listRowInsets(.init(top: 0, leading: 5, bottom: 0, trailing: 0))
        .tint(.clear)
    }

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
                if !self.isPremiumUnlocked {
                    self.manuallyShowPaywall = true
                }
            }) {
                Text(self.isPremiumUnlocked ? "Premium Enabled" : "Purchase Premium for $0.99 to Unlock")
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
        .allowsHitTesting(!self.isPremiumUnlocked)
    }
}

#Preview {
    NavigationStack {
        NewSettingsView(SettingsViewModel())
            .navigationBarTitleDisplayMode(.inline)
    }
}
