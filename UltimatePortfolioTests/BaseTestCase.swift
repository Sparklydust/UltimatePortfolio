//
//  BaseTestCase.swift
//  BaseTestCase
//
//  Created by Roland Lariotte on 13/02/2021.
//

import CoreData
import XCTest
@testable import UltimatePortfolio

class BaseTestCase: XCTestCase {

  var dataController: DataController!
  var managedObjectContext: NSManagedObjectContext!

  override func setUpWithError() throws {
    try super.setUpWithError()
    dataController = DataController(inMemory: true)
    managedObjectContext = dataController.container.viewContext
  }
}
