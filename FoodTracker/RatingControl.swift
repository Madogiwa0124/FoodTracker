//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Madogiwa on 2019/05/07.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
  //MARK: Properties
  private var ratingButtons = [UIButton]()
  var rating = 0 {
    didSet {
      // ratingが変更されたらボタンの状態変更処理を呼び出す。
      updateButtonsSelectionStates()
    }
  }

  //MARK: Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupButtons()
  }

  required init(coder: NSCoder) {
    super.init(coder: coder)
    setupButtons()
  }

  private func setupButtons() {
    // 既存ボタンの削除
    for button in ratingButtons {
      // SubViewから削除
      removeArrangedSubview(button)
      // SuperViewから削除
      button.removeFromSuperview()
    }
    // プロパティから削除
    ratingButtons.removeAll()

    // ボタンで仕様する画像のロード
    let bundle = Bundle(for: type(of: self))
    let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
    let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
    let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)

    for index in 0..<starCount {
      // ボタンを作成
      let button = UIButton()
      // ボタンの画像を定義
      button.setImage(emptyStar, for: .normal)
      button.setImage(filledStar, for: .selected)
      button.setImage(highlightedStar, for: .highlighted)
      button.setImage(highlightedStar, for: [.highlighted, .selected])
      // ボタンの説明を追加
      button.accessibilityLabel = "Set \(index + 1) star rating"
      // ボタンのconstraintsを初期化
      button.translatesAutoresizingMaskIntoConstraints = false
      // ボタンのconstraintsを定義
      button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
      button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
      // ボタンのイベントを追加
      button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
      // StackViewにボタンを追加
      addArrangedSubview(button)
      // プロパティにボタンを追加
      ratingButtons.append(button)
      // ボタンの状態を更新
      updateButtonsSelectionStates()
    }
  }

  //MARK: Button Action
  @objc func ratingButtonTapped(button: UIButton) {
    // 押下されたbuttonのindexを取得
    guard let index = ratingButtons.index(of: button) else {
      // indexが取得出来なかったらerror
      fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
    }
    // index + 1を押下した評価とする※1個目星が押されたら1点
    let selectedRating = index + 1
    // 押下済みの評価値と同じ場合はリセット
    if selectedRating == rating {
      rating = 0
    }
    // そうじゃない場合は評価値を反映
    else {
      rating = selectedRating
    }
  }

  private func updateButtonsSelectionStates() {
    // 評価値以下のボタンをすべて選択済みにする
    for (index, button) in ratingButtons.enumerated() {
      button.isSelected = index < rating
      // accessibilityHint(要素に対するアクションの結果を説明)の生成
      let hintString: String?
      if rating == index + 1 {
        hintString = "Tap to reset the raiting zero."
      } else {
        hintString = nil
      }
      // accessibilityValue(値がラベルで表されていない場合の要素の現在の値)の生成
      let valueString: String
      switch (rating) {
      case 0:
        valueString = "No ration set."
      case 1:
        valueString = "1 star set"
      default:
        valueString = "\(index + 1) star set."
      }
      // buttonにaccessibilityHintを設定
      button.accessibilityHint = hintString
      // buttonにaccessibilityValueを設定
      button.accessibilityValue = valueString
    }
  }

  // MARK: Inspectable properties
  @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
    didSet { setupButtons() }
  }
  @IBInspectable var starCount: Int = 5 {
    didSet { setupButtons() }
  }
}
