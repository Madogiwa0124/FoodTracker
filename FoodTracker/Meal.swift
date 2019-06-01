//
//  Meal.swift
//  FoodTracker
//
//  Created by Madogiwa on 2019/05/12.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import UIKit
import os.log

class Meal: NSObject, NSCoding {
  // MARK: Properties
  var name: String
  var photo: UIImage?
  var rating: Int

  // MARK: Archiving Paths
  // 保存先のURL及びディレクトリを定義
  static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
  static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")

  // MARK: Types
  struct PropertyKey {
    static let name = "name"
    static let photo = "photo"
    static let rating = "rating"
  }

  // nilが返却される可能性があるためinit?(失敗可能イニシャライザ)で定義
  init?(name: String, photo: UIImage?, rating: Int) {
    // 名前が空白またはraitingは0未満だったらnilを返す
    guard !name.isEmpty else { return nil }
    guard (0...5).contains(rating) else { return nil }

    self.name = name
    self.photo = photo
    self.rating = rating
  }

  required convenience init?(coder aDecoder: NSCoder) {
    // 名前は必須、Stringに復号出来なかったらErrorにする。
    guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
      os_log("Unable to decode the name for Meal Object.", log: OSLog.default, type: .debug)
      return nil
    }
    // 画像は任意なので、UIImageに復号出来なければnilにする。
    let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
    // 評価は必須、かつIntに復号出来なかったらError
    let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
    // 初期化処理を呼び出し
    self.init(name: name, photo: photo, rating: rating)
  }

  // MARK: NSCoding
  func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: PropertyKey.name)
    aCoder.encode(photo, forKey: PropertyKey.photo)
    aCoder.encode(rating, forKey: PropertyKey.rating)
  }
}

