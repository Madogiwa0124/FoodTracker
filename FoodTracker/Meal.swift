//
//  Meal.swift
//  FoodTracker
//
//  Created by Madogiwa on 2019/05/12.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import UIKit

class Meal {
  // MARK: Properties
  var name: String
  var photo: UIImage?
  var rating: Int

  // nilが返却される可能性があるためinit?(失敗可能イニシャライザ)で定義
  init?(name: String, photo: UIImage?, rating: Int) {
    // 名前が空白またはraitingは0未満だったらnilを返す
    guard !name.isEmpty else { return nil }
    guard (0...5).contains(rating) else { return nil }

    self.name = name
    self.photo = photo
    self.rating = rating
  }
}

