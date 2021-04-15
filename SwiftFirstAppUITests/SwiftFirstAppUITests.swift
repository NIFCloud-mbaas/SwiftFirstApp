//
//  SwiftFirstAppUITests.swift
//  SwiftFirstAppUITests
//
//  Created by HungNV on 4/15/21.
//  Copyright © 2021 NIFTY Corporation. All rights reserved.
//

import XCTest

class SwiftFirstAppUITests: XCTestCase {
    var app: XCUIApplication!
    var btnStart: XCUIElement!
    var tfCount: XCUIElement!
    let strName = "Doremon"
    
    // MARK: - Setup for UI Test
    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        btnStart = app.buttons["btnStart"]
        tfCount = app.textFields["tfCount"]
    }
    
    func testGameScreen() throws {
        app.launch()
        XCTAssertTrue(app.staticTexts["連打アプリ"].waitForExistence(timeout: 10))
        XCTAssert(tfCount.exists)
        XCTAssert(btnStart.exists)
        btnStart.tap()
        XCTAssertTrue(app.staticTexts["タイムアップ！"].waitForExistence(timeout: 15))
        let alert = app.alerts["スコア登録"]
        let tfName = alert.scrollViews.otherElements.textFields.element
        tfName.tap()
        tfName.typeText(strName)
        let btnOK = alert.scrollViews.otherElements.buttons["OK"]
        btnOK.tap()
        XCTAssertTrue(app.staticTexts["\(strName)さんのスコアは0連打でした"].waitForExistence(timeout: 10))
    }
    
    func testRankingScreen() throws {
        app.launch()
        let rightBar = app.navigationBars.buttons["ランキングを見る"]
        XCTAssert(rightBar.exists)
        rightBar.tap()
        XCTAssertTrue(app.staticTexts["ランキング"].waitForExistence(timeout: 10))
        let strNoData = app.filterCells(containing: "no data").element
        XCTAssert(strNoData.exists)
        scrollToLastCell()
        let backBar = app.navigationBars.buttons["Back"]
        XCTAssert(backBar.exists)
        backBar.tap()
    }
    
    private func scrollToLastCell() {
        let table = app.tables.element(boundBy: 0)
        let lastCell = table.cells.element(boundBy: table.cells.count-1)
        table.scrollToElement(element: lastCell)
    }
}

// MARK: - XCUIApplication
extension XCUIApplication {
    // Filter cells in TableView
    func filterCells(containing labels: String...) -> XCUIElementQuery {
        var cells = self.cells
        for label in labels {
            cells = cells.containing(NSPredicate(format: "label CONTAINS %@", label))
        }
        return cells
    }
}

extension XCUIElement {
    func scrollToElement(element: XCUIElement) {
        while !element.visible() {
            swipeUp()
        }
    }
    
    func visible() -> Bool {
        guard self.exists && !self.frame.isEmpty else { return false }
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(self.frame)
    }
    
    func tap(button: String) {
        XCUIApplication().keyboards.buttons[button].tap()
    }
}
