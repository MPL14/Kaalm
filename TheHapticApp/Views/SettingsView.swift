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

    @AppStorage(Constants.gridRows) var currentGridRows: Double = 16.0
    @AppStorage(Constants.gridCols) var currentGridCols: Double = 16.0
    @AppStorage(Constants.dotSize) var currentDotSize: Double = 10.0
    @AppStorage(Constants.feedbackIntensity) var feedbackIntensity: Double = 1.0
    @AppStorage(Constants.myColor) var myColor: String = Constants.defaultColor
    @AppStorage(Constants.hapticsEnabled) var hapticsEnabled: Bool = true

    // MARK: - State
    @ObservedObject private var viewModel: SettingsViewModel

    init(_ viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List {
            Section(viewModel.generalSectionText) {
                aboutButton

                requestReviewButton
            }

            Section(viewModel.customizeSectionText) {
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
                Text(viewModel.supportSectionText)
            } footer: {
                Text(viewModel.appVersionNumber)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 15)
                    .foregroundStyle(.secondary)
            }
        }
        .tint(Color(Constants.defaultColor))
        .navigationTitle(viewModel.settingsViewTitle)
        .task {
            await self.viewModel.verifyPremiumUnlocked()
        }
        .sheet(isPresented: self.$viewModel.manuallyShowPaywall) {
            PaywallView(displayCloseButton: true)
                .onPurchaseCompleted { customerInfo in
                    self.viewModel.verifyPremiumEntitlement(for: customerInfo)
                }
                .onRestoreCompleted { customerInfo in
                    self.viewModel.verifyPremiumEntitlement(for: customerInfo)
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
                await viewModel.restorePurchasesButtonTapped()
            }
        }
    }

    private var appearanceControls: some View {
        Group {
            HStack {
                Text(viewModel.gridRowsTitle)
                Slider(value: $currentGridRows, in: 3...18)
            }

            HStack {
                Text(viewModel.gridColsTitle)
                Slider(value: $currentGridCols, in: 3...18)
            }

            HStack {
                Text(viewModel.gridDotSizeTitle)
                Slider(value: $currentDotSize, in: 3...20)
            }

            HStack {
                Text(viewModel.gridFeedbackIntensityTitle)
                Slider(value: $feedbackIntensity, in: 0...1)
            }

            HStack {
                Toggle(isOn: $hapticsEnabled) {
                    Text(viewModel.gridHapticsEnabledTitle)
                }
                .tint(.green)
            }

            HStack {
                CustomColorPicker(selectedColor: $myColor)
                    .colors(
                        [
                            Constants.defaultColor,
                            Constants.clayColor,
                            Constants.oceanColor,
                            Constants.roseColor,
                            Constants.sageColor
                        ]
                    )
                    .title("Grid Color")
                    .highlightColor(Color(Constants.defaultColor))
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
    }
}
