//
//  TheHapticAppUITests.swift
//  TheHapticAppUITests
//
//  Created by Giorgio Latour on 2/6/24.
//

import XCTest

final class TheHapticAppOnboardingUITests: XCTestCase {

    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIDevice.shared.orientation = .portrait
        app.launch()
    }

    override func tearDownWithError() throws { }

    func testSwipeToUnlockShowsNewScreen() throws {
    }
}
