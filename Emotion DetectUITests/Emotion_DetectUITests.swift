//
//  Emotion_DetectUITests.swift
//  Emotion DetectUITests
//
//  Created by Peter Entwistle on 19/02/2017.
//  Copyright © 2017 Peter Entwistle. All rights reserved.
//

import XCTest

class Emotion_DetectUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        XCUIDevice.shared().orientation = .portrait
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let button = XCUIApplication().buttons["SwitchCamera"]
        button.tap()
        button.tap()
        XCUIApplication().buttons["Start"].tap()
        XCUIApplication().buttons["Stop"].tap()
        
        let tabBarsQuery = XCUIApplication().tabBars
        tabBarsQuery.buttons["Video"].tap()
        tabBarsQuery.buttons["Photo"].tap()
        tabBarsQuery.buttons["Settings"].tap()
    }
    
}
