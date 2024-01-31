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
    @Published var showingMailError = false

    public var mailErrorMessageTitle: String = String(localized: "Error sending mail.")
    public var mailErrorMessage: String = String(localized: "Unable to send email from app. Are you using the Mail app?")

    public var appVersionNumber: String {
        return String(localized: "The Haptic App, v\(Bundle.main.releaseVersionNumber ?? "nil")")
    }

    public var rateButtonText: String = String(localized: "Rate The Haptic App")
    public var supportEmailButtonText: String = String(localized: "Need Support?")
    public var restorePurchasesButtonText: String = String(localized: "Restore Purchases")

    public func supportEmailButtonTapped() {
        if MFMailComposeViewController.canSendMail() {
            self.isShowingMailView = true
        } else {
            self.showingMailError = true
        }
    }

    init() {
        print("init settings view model")
    }
}
