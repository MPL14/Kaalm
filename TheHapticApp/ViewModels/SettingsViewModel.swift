//
//  SettingsViewModel.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/30/24.
//

import MessageUI
import SwiftUI

final class SettingsViewModel: ObservableObject {
    // MARK: - State
    // Send Support Email
    @Published var mailResult: Result<MFMailComposeResult, Error>? = nil
    @Published var isShowingMailView = false

    @Published var alertMessageTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var showingAlert = false

    // MARK: - Properties
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

    public let rateButtonText: String = String(localized: "Rate The Haptic App")
    public let supportWebsiteButtonText: String = String(localized: "Support Website")
    public let privacyPolicyWebsiteButtonText: String = String(localized: "Privacy Policy")
    public let supportEmailButtonText: String = String(localized: "Contact Us")
    public let restorePurchasesButtonText: String = String(localized: "Restore Purchases")

    public func supportEmailButtonTapped() {
        if MFMailComposeViewController.canSendMail() {
            self.isShowingMailView = true
        } else {
            self.alertMessage = self.mailErrorMessage
            self.alertMessageTitle = self.mailErrorMessageTitle
            self.showingAlert = true
        }
    }

    @MainActor public func restorePurchasesButtonTapped() async {
        let result = await PurchaseManager.shared.restorePurchases()

        switch result {
        case .success(let success):
            self.alertMessageTitle = success ? self.restorePurchaseSuccessMessageTitle : self.restorePurchaseFailureMessageTitle
            self.alertMessage = success ? self.restorePurchaseSuccessMessage : self.restorePurchaseFailureMessage
            self.showingAlert = true
        case .failure(let failure):
            self.alertMessageTitle = self.restorePurchaseErrorMessageTitle
            self.alertMessage = failure.localizedDescription
            self.showingAlert = true
        }
    }
}
