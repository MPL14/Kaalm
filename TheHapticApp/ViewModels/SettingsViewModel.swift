//
//  SettingsViewModel.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/30/24.
//

import MessageUI
import RevenueCat
import SwiftUI

final class SettingsViewModel: ObservableObject {
    // MARK: - State
    // Send Support Email
    @Published var mailResult: Result<MFMailComposeResult, Error>? = nil
    @Published var isShowingMailView = false

    // For premium settings.
    @Published var isPremiumUnlocked: Bool = false
    @Published var manuallyShowPaywall: Bool = false

    @Published var alertMessageTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var showingAlert = false

    // MARK: - Properties
    public let settingsViewTitle: String = String(localized: "Settings")

    // List Section Titles
    public let generalSectionText: String = String(localized: "General")
    public let customizeSectionText: String = String(localized: "Customize")
    public let supportSectionText: String = String(localized: "Support")

    // Button Titles
    public let aboutButtonText: String = String(localized: "About")
    public let privacyPolicyWebsiteButtonText: String = String(localized: "Privacy Policy")
    public let rateButtonText: String = String(localized: "Rate The Haptic App")
    public let restorePurchasesButtonText: String = String(localized: "Restore Purchases")
    public let supportEmailButtonText: String = String(localized: "Contact Us")
    public let supportWebsiteButtonText: String = String(localized: "Support Website")

    public let gridRowsTitle: String = String(localized: "Grid Rows")
    public let gridColsTitle: String = String(localized: "Grid Columns")
    public let gridDotSizeTitle: String = String(localized: "Dot Size")
    public let gridFeedbackIntensityTitle: String = String(localized: "Feedback Intensity")
    public let gridHapticsEnabledTitle: String = String(localized: "Haptics Enabled")

    public let premiumEnabledTitle: String = String(localized: "Premium Enabled")
    public let premiumNotEnabledTitle: String = String(localized: "Purchase Premium for $0.99 to Unlock")

    // Alert Texts
    public let mailErrorMessageTitle: String = String(localized: "Error sending mail")
    public let mailErrorMessage: String = String(localized: "Unable to send email from app. Are you using the Mail app?")

    public let restorePurchaseErrorMessageTitle: String = String(localized: "Error restoring purchases")
    public let restorePurchaseFailureMessageTitle: String = String(localized: "No Purchases")
    public let restorePurchaseFailureMessage: String = String(localized: "There were no purchases restored.")
    public let restorePurchaseSuccessMessageTitle: String = String(localized: "Success")
    public let restorePurchaseSuccessMessage: String = String(localized: "Your purchases were restored successfully!")

    public var appVersionNumber: String {
        return String(localized: "The Haptic App, v\(Bundle.main.releaseVersionNumber ?? "nil")")
    }

    // MARK: - Public Functions
    public func supportEmailButtonTapped() {
        if MFMailComposeViewController.canSendMail() {
            self.isShowingMailView = true
        } else {
            self.alertMessage = self.mailErrorMessage
            self.alertMessageTitle = self.mailErrorMessageTitle
            self.showingAlert = true
        }
    }

    // MARK: - RevenueCat
    @MainActor public func restorePurchasesButtonTapped() async {
        let result = await PurchaseManager.shared.restorePurchases()

        switch result {
        case .success(let success):
            self.alertMessageTitle = success ? self.restorePurchaseSuccessMessageTitle : self.restorePurchaseFailureMessageTitle
            self.alertMessage = success ? self.restorePurchaseSuccessMessage : self.restorePurchaseFailureMessage
            self.isPremiumUnlocked = success
            self.showingAlert = true
        case .failure(let failure):
            self.alertMessageTitle = self.restorePurchaseErrorMessageTitle
            self.alertMessage = failure.localizedDescription
            self.showingAlert = true
        }
    }

    @MainActor public func verifyPremiumUnlocked() async {
        self.isPremiumUnlocked = await PurchaseManager.shared.isPremiumUnlocked()
    }

    public func verifyPremiumEntitlement(_ entitlement: String = Constants.premiumEntitlement, for customerInfo: CustomerInfo) {
        self.isPremiumUnlocked = customerInfo.entitlements[Constants.premiumEntitlement]?.isActive == true
    }
}
