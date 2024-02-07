//
//  TheHapticAppSettingsScreenUITests.swift
//  TheHapticAppUITests
//
//  Created by Giorgio Latour on 2/7/24.
//

import XCTest

final class TheHapticAppSettingsScreenUITests: XCTestCase {

    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        // Make sure onboarding is completed so we aren't stuck there.
        app.setCompletedOnboarding()
        app.launch()
    }

    override func tearDownWithError() throws { }

    func testProfileButtonGoesToSettings() {
        let profileButton = app.buttons["personalizationSettings"]

        profileButton.tap()

        XCTAssertTrue(app.navigationBars["Settings"].exists)
    }

    func testAboutButtonGoesToAboutView() {
        let profileButton = app.buttons["personalizationSettings"]
        profileButton.tap()

        let aboutButton = app/*@START_MENU_TOKEN@*/.buttons["aboutButton"]/*[[".cells",".buttons[\"About\"]",".buttons[\"aboutButton\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        aboutButton.tap()

        XCTAssertTrue(app.navigationBars["About"].exists)
    }

    func testRateButtonShowsRatingAlert() {
        let profileButton = app.buttons["personalizationSettings"]
        profileButton.tap()
        let requestReviewButton = app.buttons["requestReviewButton"]
        requestReviewButton.tap()
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["requestReviewButton"]/*[[".cells.buttons[\"requestReviewButton\"]",".buttons[\"requestReviewButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        let elementsQuery = app.scrollViews.otherElements.staticTexts["Enjoying The Haptic App?"]
        
        let rateViewExists = elementsQuery.waitForExistence(timeout: 2)

        XCTAssertTrue(rateViewExists)
    }

    func testPurchaseButtonOpensPaywall() {
        let profileButton = app.buttons["personalizationSettings"]
        profileButton.tap()

        let purchaseButton = app.buttons["purchaseButton"]
        purchaseButton.tap()

        let paywallPurchaseButton = app.buttons["Purchase"]
        XCTAssertTrue(paywallPurchaseButton.exists)
    }
}
