//
//  UIDemoUITests.swift
//  UIDemoUITests
//
//  Created by Vladimir Obrizan on 20.06.2020.
//  Copyright © 2020 First Institute of Reliable Software. All rights reserved.
//

import XCTest

class UIDemoUITests: XCTestCase {
    
    var app: XCUIApplication?
    
    override func setUp() {
        app = XCUIApplication()
        app!.launch()
        
        app!.tables/*@START_MENU_TOKEN@*/.staticTexts["SearchVC"]/*[[".cells[\"reuseIdentifier\"].staticTexts[\"SearchVC\"]",".staticTexts[\"SearchVC\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    override func tearDown() {
        let masterNavigationBar = app!.navigationBars["Master"]
        masterNavigationBar.buttons["Cancel"].tap()
        masterNavigationBar.buttons["Master"].tap()
    }

    func testFiltering() throws {
        XCTAssertFalse(app!.staticTexts["Apple"].exists)

        // Step 1.
        app!.searchFields["Search categories"].typeText("A")
        XCTAssertTrue(app!.staticTexts["Apple"].exists)
        XCTAssertTrue(app!.staticTexts["Apricot"].exists)
        XCTAssertTrue(app!.staticTexts["Avocado"].exists)
        XCTAssertFalse(app!.staticTexts["Banana"].exists)
        
        // Step 2.
        app!.searchFields["Search categories"].typeText("p")
        waitForAbsence(element: app!.staticTexts["Avocado"])
        XCTAssertTrue(app!.staticTexts["Apple"].exists)
        XCTAssertTrue(app!.staticTexts["Apricot"].exists)
        
        // Step 3.
        app!.searchFields["Search categories"].typeText("p")
        XCTAssertTrue(app!.staticTexts["Apple"].exists)
        waitForAbsence(element: app!.staticTexts["Apricot"])

        // Step 4.
        app!.searchFields["Search categories"].typeText("o")
        waitForAbsence(element: app!.staticTexts["Apple"])
        XCTAssertTrue(app!.tables.staticTexts["Item coming soon! Tap to add."].exists)
    }
    
    func waitForAbsence(element: XCUIElement) {
        let predicate = NSPredicate(format: "exists == 0")
        let e = expectation(for: predicate, evaluatedWith: element, handler: nil)
        wait(for: [e], timeout: 5)
    }

}
