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

    public var mailErrorMessageTitle: String = "Error sending mail."
    public var mailErrorMessage: String = "Unable to send email from app. Are you using the Mail app?"

    public var appVersionNumber: String {
        return "The Haptic App, v\(Bundle.main.releaseVersionNumber ?? "nil")"
    }

    public var rateButtonText: String = "Rate The Haptic App"

    public var supportEmailButtonText: String = "Need Support?"

    public func supportEmailButtonTapped() {
        if MFMailComposeViewController.canSendMail() {
            self.isShowingMailView = true
        } else {
            self.showingMailError = true
        }
    }
}
