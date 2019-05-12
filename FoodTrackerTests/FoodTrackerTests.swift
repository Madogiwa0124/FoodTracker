//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Madogiwa on 2019/03/09.
//  Copyright © 2019年 Apple Inc. All rights reserved.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {
  // MARK: Meal Class Tests
  func testMealInitializationSucceeds() {
    // Zero rating
    let zeroRatingMeal = Meal.init(name: "Zere", photo: nil, rating: 0)
    XCTAssertNotNil(zeroRatingMeal)
    
    // Highest positive rating
    let positiveMeal = Meal.init(name: "Positive", photo: nil, rating: 5)
    XCTAssertNotNil(positiveMeal)
  }

  func testMealInitializationFails() {
    // Negative rating
    let negativeRationgMeal = Meal.init(name: "Zere", photo: nil, rating: -1)
    XCTAssertNil(negativeRationgMeal)

    // Enpty name
    let emptyNameMeal = Meal.init(name: "", photo: nil, rating: 0)
    XCTAssertNil(emptyNameMeal)

    // Rating exceeds maximum
    let exceedRatingMeal = Meal.init(name: "Exceed", photo: nil, rating: 6)
    XCTAssertNil(exceedRatingMeal)
  }
}
