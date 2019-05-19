//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Madogiwa on 2019/05/14.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController {
  // MARK: properties
  var meals = [Meal]()

  override func viewDidLoad() {
    super.viewDidLoad()
    loadSampleMeals()
  }

  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return meals.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Storyboard上で指定した識別子を設定
    let cellIdentifier = "MealTableViewCell"
    // cellの初期化
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: cellIdentifier,
      for: indexPath
    // 取得したClassがMealTableViewCellじゃなかったらError
    ) as? MealTableViewCell else {
      fatalError("The dequeued cell is not an instance of MealTableViewCell.")
    }
    // 表示すべき食事データの取得
    let meal = meals[indexPath.row]
    // 取得した食事データからCellに値を設定
    cell.nameLabel.text = meal.name
    cell.photoImageView.image = meal.photo
    cell.ratingControl.rating = meal.rating
    // Cellを返却
    return cell
  }


  // MARK: Actions
  @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
    // 遷移元のViewControllerから食事情報を取得
    if let sourceViewController = sender.source as? MealViewController,
       let meal = sourceViewController.meal
    {
      // 取得した食事情報をTableViewに追加
      let newIndexPath = IndexPath(row: meals.count, section: 0)
      meals.append(meal)
      tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
  }

  // MARK: private methods
  private func loadSampleMeals() {
    let photo1 = UIImage(named: "meal1")
    let photo2 = UIImage(named: "meal2")
    let photo3 = UIImage(named: "meal3")

    guard let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4) else {
      fatalError("Unable to instantiate meal1")
    }
    guard let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5) else {
      fatalError("Unable to instantiate meal2")
    }
    guard let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
      fatalError("Unable to instantiate meal3")
    }
    meals += [meal1, meal2, meal3]
  }
}
