//
//  Constants.swift
//  TheHapticApp
//


import Foundation

struct Constants {
    // MARK: - App Support URLs
    static let appSupportPageURL: URL? = URL(string: "https://the-haptic-app-support.carrd.co/")
    static let appPrivacyPolicyURL: URL? = URL(string: "https://the-haptic-app-privacy.carrd.co/")

    // MARK: - UserDefaults Keys
    static let onboardingComplete: String = "onboardingComplete"

    static let darkModePreferred: String = "darkModePreferred"
    static let dotSize: String = "dotSize"
    static let feedbackIntensity: String = "feedbackIntensity"
    static let feedbackSharpness: String = "feedbackSharpness"
    static let gridRows: String = "gridRows"
    static let gridCols: String = "gridCols"
    static let myColor: String = "myColor"
    static let hapticsEnabled: String = "hapticsEnabled"

    // Min and max dot size, grid size.
    static let defaultGridSize: Double = 16.0
    static let defaultDotSize: Double = 10.0
    
    static let minGridSize: Double = 5.0
    static let maxGridSize: Double = 20.0
    static let minDotSize: Double = 10.0
    static let maxDotSize: Double = 50.0

    // MARK: - Stock Color Assets
    static let backgroundColor: String = "Background"
    static let accentColor: String = "Default"
    static let grayColor: String = "Ice Gray"
    static let charcoalColor: String = "Charcoal"
    static let deepBlueColor: String = "Deep Blue"
    static let roseColor: String = "Rose"
    static let sageColor: String = "Sage"
    static let silverColor: String = "Silver"

    // MARK: - RevenueCat Premium Entitlement
    static var premiumEntitlement: String = "TheHapticApp.Premium"
}
