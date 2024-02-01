//
//  Constants.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/31/24.
//

import Foundation

struct Constants {
    // MARK: - App Support URLs
    static let appSupportPageURL: URL? = URL(string: "https://the-haptic-app-support.carrd.co/")
    static let appPrivacyPolicyURL: URL? = URL(string: "https://the-haptic-app-privacy.carrd.co/")

    // MARK: - UserDefaults Keys
    static let onboardingComplete: String = "onboardingComplete"

    static let dotSize: String = "dotSize"
    static let feedbackIntensity: String = "feedbackIntensity"
    static let gridRows: String = "gridRows"
    static let gridCols: String = "gridCols"
    static let myColor: String = "myColor"
    static let hapticsEnabled: String = "hapticsEnabled"

    // MARK: - Stock Color Assets
    static let backgroundColor: String = "Background"
    static let defaultColor: String = "Default"
    static let clayColor: String = "Clay"
    static let oceanColor: String = "Ocean"
    static let roseColor: String = "Rose"
    static let sageColor: String = "Sage"

    // MARK: - RevenueCat Premium Entitlement
    static var premiumEntitlement: String = "TheHapticApp.Premium"
}
