//
//  TheHapticAppUITests.swift
//  TheHapticAppUITests
//
//  Created by Giorgio Latour on 2/6/24.
//

import XCTest

final class TheHapticAppOnboardingUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIDevice.shared.orientation = .portrait
    }

    override func tearDownWithError() throws {
        app.terminate()
        app = nil
    }

    func testShowOnboardingOnFirstLaunch() {
        app = XCUIApplication()
        app.setCompletedOnboarding(false)

        app.launch()

        let swipeToUnlock = app/*@START_MENU_TOKEN@*/.otherElements["swipeToUnlock"]/*[[".otherElements[\"Swipe to Unlock\"]",".otherElements[\"swipeToUnlock\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(swipeToUnlock.exists)
    }

    func testShowMainViewAfterOnboardingDone() {
        app = XCUIApplication()
        app.setCompletedOnboarding(true)

        app.launch()

        let swipeToUnlock = app/*@START_MENU_TOKEN@*/.otherElements["swipeToUnlock"]/*[[".otherElements[\"Swipe to Unlock\"]",".otherElements[\"swipeToUnlock\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertFalse(swipeToUnlock.exists)

        let hapticGrid = app.otherElements["hapticGrid"]
        XCTAssertTrue(hapticGrid.exists)
    }
}

extension XCUIApplication {
    func setCompletedOnboarding(_ onboardingComplete: Bool = true) {
        launchArguments += ["-onboardingComplete", onboardingComplete ? "true" : "false"]
    }
}
