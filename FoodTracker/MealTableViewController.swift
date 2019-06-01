//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Madogiwa on 2019/05/14.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {
  // MARK: properties
  var meals = [Meal]()

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.leftBarButtonItem = editButtonItem
    // 保存済みの食事を取得、取得出来なかったらサンプルを取得
    if let savedMeals = loadMeals() {
      meals += savedMeals
    } else {
      loadSampleMeals()
    }
  }

  //MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    // 遷移先によって処理を分岐
    switch(segue.identifier ?? "") {
    // 新規追加画面の場合
    case "AddItem":
      os_log("Add a new meal.", log: OSLog.default, type: .debug)
    // 詳細画面の場合
    case "ShowDetail":
      // 遷移先のViewControllerを取得
      guard let mealDetailViewController = segue.destination as? MealViewController else {
        fatalError("Unexpected destination: \(segue.destination)")
      }
      // 選択された食事のセルを取得
      guard let selectMealCell = sender as? MealTableViewCell else {
        fatalError("Unexpected sender: \(String(describing: sender))")
      }
      // 選択された食事のセルの位置を取得
      guard let indexPath = tableView.indexPath(for: selectMealCell) else {
        fatalError("The selected cell is not being displayed by the table")
      }
      // 選択された食事を取得
      let selectedMeal = meals[indexPath.row]
      // 遷移先のViewControllerに食事を設定
      mealDetailViewController.meal = selectedMeal
    // それ以外の場合
    default:
      // あり得ないのでError
      fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
    }
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

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      // 配列から食事を削除
      meals.remove(at: indexPath.row)
      // 食事の保存
      saveMeals()
      // Viewから食事を削除
      tableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
  }

  // MARK: Actions
  @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
    // 遷移元のViewControllerから食事情報を取得
    if let sourceViewController = sender.source as? MealViewController,
       let meal = sourceViewController.meal
    {
      // 更新
      // 更新対象のセルのパスを取得
      if let selectedIndexPath = tableView.indexPathForSelectedRow {
        // 更新対象のセルにmealを設定
        meals[selectedIndexPath.row] = meal
        // テーブルビューを更新
        tableView.reloadRows(at: [selectedIndexPath], with: .none)
      } else {
        // 新規追加
        // 取得した食事情報をTableViewに追加
        let newIndexPath = IndexPath(row: meals.count, section: 0)
        meals.append(meal)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        // Mealの保存処理
        saveMeals()
      }
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

  private func saveMeals() {
    // 保存先にmealsを保存
    let isSuccessfullSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
    if isSuccessfullSave {
      os_log("Meal successfull saved.", log: OSLog.default, type: .debug)
    } else {
      os_log("Failed to save meals...", log: OSLog.default, type: .error)
    }
  }

  private func loadMeals() -> [Meal]? {
    // 保存先からmealsを取得
    return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
  }
}
