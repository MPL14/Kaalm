//
//  TheHapticAppUnitTests.swift
//  TheHapticAppUnitTests
//
//  Created by Giorgio Latour on 2/6/24.
//

@testable import TheHapticApp
import XCTest

final class SettingsViewModelUnitTests: XCTestCase {

    var settingsViewModel: SettingsViewModel!

    override func setUpWithError() throws {
        self.settingsViewModel = SettingsViewModel(purchaseEngine: MockPurchaseEngine())
    }

    override func tearDownWithError() throws {
        self.settingsViewModel = nil
    }

    func testRestorePurchasesButtonTappedSucceedsAndRestores() async {
        await settingsViewModel.restorePurchasesButtonTappedForEntitlement("entitlementSuccessfullyRestored")

        XCTAssertEqual(settingsViewModel.alertMessageTitle, settingsViewModel.restorePurchaseSuccessMessageTitle)
        XCTAssertEqual(settingsViewModel.alertMessage, settingsViewModel.restorePurchaseSuccessMessage)
        XCTAssertTrue(settingsViewModel.isPremiumUnlocked)
        XCTAssertTrue(settingsViewModel.showingAlert)
    }

    func testRestorePurchasesButtonTappedSucceedsAndDoesntRestore() async {
        await settingsViewModel.restorePurchasesButtonTappedForEntitlement("noEntitlementsToRestore")

        XCTAssertEqual(settingsViewModel.alertMessageTitle, settingsViewModel.restorePurchaseFailureMessageTitle)
        XCTAssertEqual(settingsViewModel.alertMessage, settingsViewModel.restorePurchaseFailureMessage)
        XCTAssertFalse(settingsViewModel.isPremiumUnlocked)
        XCTAssertTrue(settingsViewModel.showingAlert)
    }

    func testRestorePurchasesButtonTappedFails() async {
        await settingsViewModel.restorePurchasesButtonTappedForEntitlement("entitlementFailedToRestore")

        XCTAssertEqual(settingsViewModel.alertMessageTitle, settingsViewModel.restorePurchaseErrorMessageTitle)
        XCTAssertEqual(settingsViewModel.alertMessage, RestoreError.restoreErrorOccurred.localizedDescription)
        XCTAssertTrue(settingsViewModel.showingAlert)
    }
}

fileprivate enum RestoreError: Error {
    case restoreErrorOccurred
    case unknownRestoreError
}

fileprivate class MockPurchaseEngine: PurchaseEngine {
    func restorePurchasesAndVerifyEntitlement(_ entitlement: String) async -> Result<Bool, Error> {
        switch entitlement {
        case "entitlementSuccessfullyRestored":
            return .success(true)
        case "noEntitlementsToRestore":
            return .success(false)
        case "entitlementFailedToRestore":
            print(RestoreError.restoreErrorOccurred.localizedDescription)
            return .failure(RestoreError.restoreErrorOccurred)
        default:
            return .failure(RestoreError.unknownRestoreError)
        }
    }
    
    func verifyPremiumUnlocked(_ entitlement: String) async -> Bool {
        return entitlement == "entitlementUnlocked"
    }
}
