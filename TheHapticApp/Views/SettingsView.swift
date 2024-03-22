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

struct SettingsView: View {
    // MARK: - Environment
    @EnvironmentObject private var hapticEngine: HapticEngine
    @Environment(\.requestReview) var requestReview
    @Environment(\.openURL) var openURL

    @AppStorage(Constants.gridRows) var currentGridRows: Double = Constants.defaultGridSize
    @AppStorage(Constants.gridCols) var currentGridCols: Double = Constants.defaultGridSize
    @AppStorage(Constants.dotSize) var currentDotSize: Double = Constants.defaultDotSize
    @AppStorage(Constants.feedbackIntensity) var feedbackIntensity: Double = 1.0
    @AppStorage(Constants.feedbackSharpness) var feedbackSharpness: Double = 1.0
    @AppStorage(Constants.myColor) var myColor: String = Constants.accentColor
    @AppStorage(Constants.hapticsEnabled) var hapticsEnabled: Bool = true
    @AppStorage(Constants.darkModePreferred) var darkModePreferred: Bool = false

    // MARK: - State
    @ObservedObject private var viewModel: SettingsViewModel

    init(_ viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List {
            Section(viewModel.generalSectionText) {
                aboutButton
                    .accessibilityIdentifier("aboutButton")

                requestReviewButton
                    .accessibilityIdentifier("requestReviewButton")
            }

            Section(viewModel.customizeSectionText) {
                appearanceControls

                manuallyPurchasePremiumButton
                    .accessibilityIdentifier("purchaseButton")
            }
            .onChange(of: feedbackIntensity) { value in
                hapticEngine.asyncPlayHaptic(
                    intensity: feedbackIntensity,
                    sharpness: feedbackSharpness
                )
            }
            .onChange(of: feedbackSharpness) { value in
                hapticEngine.asyncPlayHaptic(
                    intensity: feedbackIntensity,
                    sharpness: feedbackSharpness
                )
            }

            Section {
                supportEmailButton

                supportWebsiteButton

                privacyPolicyButton

                restorePurchasesButton
            } header: {
                Text(viewModel.supportSectionText)
            } footer: {
                Text(viewModel.appVersionNumber)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 15)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle(viewModel.settingsViewTitle)
        .task {
            await self.viewModel.verifyPremiumUnlocked()
        }
        .sheet(isPresented: self.$viewModel.manuallyShowPaywall) {
            PaywallView(displayCloseButton: true)
                .onPurchaseCompleted { _ in
                    Task {
                        await self.viewModel.verifyPremiumUnlocked()
                    }
                }
                .onRestoreCompleted { _ in
                    Task {
                        await self.viewModel.verifyPremiumUnlocked()
                    }
                }
                .accessibilityIdentifier("paywall")
        }
        .sheet(isPresented: $viewModel.isShowingMailView) {
            MailView(result: $viewModel.mailResult)
        }
        .alert(viewModel.alertMessageTitle, isPresented: $viewModel.showingAlert) {
            Button("OK") { }
        } message: {
            Text(viewModel.alertMessage)
        }
        .toolbarTitle(Text("Settings"), color: Color(myColor))
    }

    // MARK: - Subviews
    private var aboutButton: some View {
        NavigationLink {
            AboutView()
        } label: {
            Text(viewModel.aboutButtonText)
        }
    }

    private var requestReviewButton: some View {
        LinkListButton(labelText: viewModel.rateButtonText) {
            Task {
                requestReview()
            }
        }
    }

    private var supportEmailButton: some View {
        LinkListButton(labelText: viewModel.supportEmailButtonText) {
            viewModel.supportEmailButtonTapped()
        }
    }

    private var supportWebsiteButton: some View {
        LinkListButton(labelText: viewModel.supportWebsiteButtonText) {
            guard let url = Constants.appSupportPageURL else { return }
            openURL(url)
        }
    }

    private var privacyPolicyButton: some View {
        LinkListButton(labelText: viewModel.privacyPolicyWebsiteButtonText) {
            guard let url = Constants.appPrivacyPolicyURL else { return }
            openURL(url)
        }
    }

    private var restorePurchasesButton: some View {
        LinkListButton(labelText: viewModel.restorePurchasesButtonText) {
            Task(priority: .userInitiated) {
                await viewModel.restorePurchasesButtonTappedForEntitlement()
            }
        }
    }

    private var appearanceControls: some View {
        Group {
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.gridRowsTitle + ", \(Int(currentGridRows))")
                Slider(value: $currentGridRows, in: Constants.minGridSize...Constants.maxGridSize)
            }
            .accessibilityElement(children: .combine)
            .accessibilityValue("\(Int(currentGridRows)) grid rows")

            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.gridColsTitle + ", \(Int(currentGridCols))")
                Slider(value: $currentGridCols, in: Constants.minGridSize...Constants.maxGridSize)
            }
            .accessibilityElement(children: .combine)
            .accessibilityValue("\(Int(currentGridCols)) grid columns")

            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.gridDotSizeTitle + ", \(String(format: "%.1f", currentDotSize))")
                Slider(value: $currentDotSize, in: Constants.minDotSize...Constants.maxDotSize)
            }
            .accessibilityElement(children: .combine)
            .accessibilityValue("Grid dot size is \(String(format: "%.1f", currentDotSize))")

            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.gridFeedbackIntensityTitle + ", \(String(format: "%.1f", feedbackIntensity))")
                Slider(value: $feedbackIntensity, in: 0...1)
            }
            .accessibilityElement(children: .combine)
            .accessibilityValue("Feedback intensity is \(String(format: "%.2f", feedbackIntensity))")

            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.gridFeedbackSharpnessTitle + ", \(String(format: "%.1f", feedbackSharpness))")
                Slider(value: $feedbackSharpness, in: 0...1)
            }
            .accessibilityElement(children: .combine)
            .accessibilityValue("Feedback sharpness is \(String(format: "%.2f", feedbackSharpness))")

            HStack {
                Toggle(viewModel.gridHapticsEnabledTitle, isOn: $hapticsEnabled)
                    .tint(.green)
            }

            HStack {
                Toggle(viewModel.preferDarkModeTitle, isOn: $darkModePreferred)
                    .tint(.green)
            }

            HStack {
                CustomColorPicker(selectedColor: $myColor)
                    .colors(
                        [
                            Constants.charcoalColor,
                            Constants.grayColor,
                            Constants.deepBlueColor,
                            Constants.roseColor,
                            Constants.sageColor,
                            Constants.silverColor
                        ]
                    )
                    .title("Grid Color")
                    .highlightColor(Color(Constants.accentColor))
            }
        }
        .disabled(
            !self.viewModel.isPremiumUnlocked
        )
    }

    // This is a fix for putting a Button inside of a List.
    // The Button tap gesture messes with the scrolling gesture
    // of the list and causes conflicts. This is a method for
    // getting a seamless looking button.
    private var manuallyPurchasePremiumButton: some View {
        Button(action: {}) {
            Button {
                if !self.viewModel.isPremiumUnlocked {
                    self.viewModel.manuallyShowPaywall = true
                }
            } label: {
                Text(self.viewModel.isPremiumUnlocked ? viewModel.premiumEnabledTitle : viewModel.premiumNotEnabledTitle)
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
        .allowsHitTesting(!self.viewModel.isPremiumUnlocked)
    }
}

#Preview {
    NavigationStack {
        SettingsView(SettingsViewModel())
            .navigationBarTitleDisplayMode(.inline)
            .environmentObject(HapticEngine())
    }
}
