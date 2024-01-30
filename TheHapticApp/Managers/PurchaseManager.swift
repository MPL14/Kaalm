//
//  PurchasesModel.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 1/29/24.
//

import RevenueCat
import SwiftUI

final class PurchaseManager {
    static let shared = PurchaseManager()

    static var premiumEntitlement: String = "TheHapticApp.Premium"

    public func isPremiumUnlocked() async -> Bool {
        return (try? await Purchases.shared.customerInfo())?.entitlements["TheHapticApp.Premium"]?.isActive == true
    }

    public func initialize() {
        #if DEBUG
        Purchases.logLevel = .debug
        #endif
        Purchases.configure(withAPIKey: rcPublicApiKey)
    }
}
