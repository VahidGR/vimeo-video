//
//  searchUITests.swift
//  namava-assesmentUITests
//
//  Created by Vahid Ghanbarpour on 10/28/22.
//

import XCTest

class searchUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
        
        let searchBar = app.searchFields.element
        let textField = app.textFields.element
        textField.tap()
        
        app.keys["C"].tap() // if failes here, try to toggle software keyboard on your simulator
        app.keys["a"].tap()
        app.keys["t"].tap()
        
        app.keyboards.buttons["Return"].tap()
        
        let firstItem = app.collectionViews.children(matching: .any).element(boundBy: 0)
        let itemExists = firstItem.waitForExistence(timeout: 10.0)
        if itemExists {
            firstItem.tap()
        }
        
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
