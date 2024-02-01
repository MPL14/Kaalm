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

    public func isPremiumUnlocked() async -> Bool {
        return (try? await Purchases.shared.customerInfo())?.entitlements[Constants.premiumEntitlement]?.isActive == true
    }

    public func initialize() {
        #if DEBUG
        Purchases.logLevel = .debug
        #endif
        Purchases.configure(withAPIKey: rcPublicApiKey)
    }

    public func restorePurchases() async -> Result<Bool, Error> {
        do {
            let customerInfo = try await Purchases.shared.restorePurchases()
            print("here is the customerinfo after restore")
            print(customerInfo)
            // The restore process can be successful but not
            // restore e.g. if a user never purchased premium access.
            let successfulRestore = customerInfo.entitlements[Constants.premiumEntitlement]?.isActive == true
            return .success(successfulRestore)
        } catch {
            // If the restore process throws an error,
            // return failure.
            return .failure(error)
        }
    }
}
