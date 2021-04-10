//
//  AssetTests.swift
//  UltimatePortfolioTests
//
//  Created by Roland Lariotte on 13/02/2021.
//

import XCTest
@testable import UltimatePortfolio

class AssetTests: XCTestCase {

  func testColorsExist() {
    for color in Project.colors {
      XCTAssertNotNil(UIColor(named: color), "Failed to load color '\(color)' from asset catalog")
    }
  }

  func testJSONLoadsCorrectly() {
    XCTAssertFalse(Award.allAwards.isEmpty, "Failed to load awards from JSON")
  }
}
