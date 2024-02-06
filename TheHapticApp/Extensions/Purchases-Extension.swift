//
//  Purchases-Extension.swift
//  TheHapticApp
//
//  Created by Giorgio Latour on 2/6/24.
//

import Foundation
import RevenueCat

protocol PurchaseEngine {
    func restorePurchasesAndVerifyEntitlement(_ entitlement: String) async -> Result<Bool, Error>
    func verifyPremiumUnlocked(_ entitlement: String) async -> Bool
}

extension Purchases: PurchaseEngine {
    /// Retrieves customer information and verifies the specified entitlement.
    /// - Parameter _ entitlement: The entitlement to verify.
    func verifyPremiumUnlocked(_ entitlement: String) async -> Bool {
        return (try? await customerInfo())?.entitlements[entitlement]?.isActive == true
    }

    /// Initiates a restore purchases command and returns a Result.
    /// If the restore is successful, we return Result<Bool>. The Bool
    /// depends on if the specified entitlement is active. The restore
    /// purchase command can also fail, in which case we return Result<Error>.
    /// - Parameter _ entitlement: The entitlement to verify after restoring purchases.
    func restorePurchasesAndVerifyEntitlement(_ entitlement: String) async -> Result<Bool, Error> {
        do {
            let customerInfo = try await restorePurchases()

            // The restore process can be successful but not
            // restore e.g. if a user never purchased premium access.
            let successfulRestore = customerInfo.entitlements[entitlement]?.isActive == true
            return .success(successfulRestore)
        } catch {
            // If the restore process throws an error,
            // return failure.
            return .failure(error)
        }
    }
}

