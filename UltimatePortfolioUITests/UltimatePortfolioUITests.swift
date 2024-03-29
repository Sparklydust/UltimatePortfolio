//
//  UltimatePortfolioUITests.swift
//  UltimatePortfolioUITests
//
//  Created by Roland Lariotte on 05/03/2021.
//

import XCTest

class UltimatePortfolioUITests: XCTestCase {

  var app: XCUIApplication!

  override func setUpWithError() throws {
    continueAfterFailure = false

    app = XCUIApplication()
    app.launchArguments = ["enable-testing"]
    app.launch()
  }

  func testAppHasFourTabs() throws {
    XCTAssertEqual(app.tabBars.buttons.count, 4,
                   "There should be 4 tabs in the app.")
  }

  func testOpenTabAddsProjects() {
    app.buttons["Open"].tap()

    XCTAssertEqual(app.tables.cells.count, .zero,
                   "There should be no list rows initially.")

    for tapCount in 1...5 {
      app.buttons["add"].tap()

      XCTAssertEqual(app.tables.cells.count, tapCount,
                     "There should be \(tapCount) list row(s) initially.")
    }
  }

  func testAddingItemInsertsRows() {
    app.buttons["Open"].tap()
    XCTAssertEqual(app.tables.cells.count, .zero,
                   "There should be no list rows initially.")

    app.buttons["add"].tap()
    XCTAssertEqual(app.tables.cells.count, 1,
                   "There should be 1 list row after adding a project.")

    app.buttons["Add New Item"].tap()
    XCTAssertEqual(app.tables.cells.count, 2,
                   "There should be 2 list rows after adding an item.")
  }

  func testingEditingProjectUpdatesCorrectly() {
    app.buttons["Open"].tap()
    XCTAssertEqual(app.tables.cells.count, .zero,
                   "There should be no list rows initially.")

    app.buttons["add"].tap()
    XCTAssertEqual(app.tables.cells.count, 1,
                   "There should be 1 list row after adding a project.")

    app.buttons["NEW PROJECT"].tap()
    app.textFields["Project name"].tap()

    app.keys["space"].tap()
    app.keys["more"].tap()
    app.keys["2"].tap()
    app.buttons["Return"].tap()

    app.buttons["Open Projects"].tap()
    XCTAssertTrue(app.buttons["NEW PROJECT 2"].exists,
                  "The new project name should be visible in the list.")
  }

  func testingEditingItemUpdatesCorrectly() {
    // Go to Open projects and add one project and one item before the test.
    testAddingItemInsertsRows()

    app.buttons["New Item"].tap()
    app.textFields["Item name"].tap()

    app.keys["space"].tap()
    app.keys["more"].tap()
    app.keys["2"].tap()
    app.buttons["Return"].tap()

    app.buttons["Open Projects"].tap()
    XCTAssertTrue(app.buttons["New Item 2"].exists,
                  "The new item should be visible in the list.")
  }

  func testAllAwardsShowLockedAlert() {
    app.buttons["Awards"].tap()

    for award in app.scrollViews.buttons.allElementsBoundByIndex {
      award.tap()

      XCTAssertTrue(app.alerts["Locked"].exists,
                    "There should be a lock alert showing for awards.")
      app.buttons["OK"].tap()
    }
  }
}
