//
//  MealViewController
//  FoodTracker
//
//  Created by Madogiwa on 2019/03/09.
//  Copyright © 2019年 Apple Inc. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController,
                      UITextFieldDelegate,
                      UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate {
  // MARK: Properties
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var ratingControl: RatingControl!

  @IBOutlet weak var SaveButton: UIBarButtonItem!
  
  // 食事リストから渡される食事情報を保存
  var meal: Meal?

  override func viewDidLoad() {
    super.viewDidLoad()
    // Handle the text field’s user input through delegate callbacks.
    nameTextField.delegate = self
    // 既存の食事を編集する場合は、食事の情報を画面項目に設定
    if let meal = meal {
      navigationItem.title = meal.name
      nameTextField.text = meal.name
      photoImageView.image = meal.photo
      ratingControl.rating = meal.rating
    }
    // SaveButtonの状態を更新
    updateSaveButtonState()
  }

  //MARK: UITextFieldDelegate
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // Hide the keyboard.
    textField.resignFirstResponder()
    return true
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    // 名前入力中は、SaveButtonを非活性に
    SaveButton.isEnabled = false
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    // 名前入力後にボタンの状態更新とタイトルへの反映を行う
    updateSaveButtonState()
    navigationItem.title = nameTextField.text
  }

  // MARK: UIImagePickerControllerDelegate
  // MEMO: ユーザーが画像選択をキャンセルしたら呼ばれる
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    // 画像選択画面を閉じる.
    dismiss(animated: true, completion: nil)
  }

  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    // 画像にはいろいろな種類があるので、使いたいオリジナル画像だけを取得
    guard let selectedImage = info[.originalImage] as? UIImage else {
      fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
    }
    photoImageView.image = selectedImage
    // 画像選択画面を閉じる.
    dismiss(animated: true, completion: nil)
  }

  // MARK: Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    // 押下されたbuttonがSaveButtonじゃない場合はlogを出力してreturn
    guard let button = sender as? UIBarButtonItem, button === SaveButton else {
      os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
      return
    }

    // 入力値からMealオブジェクトを作成
    let name = nameTextField.text ?? ""
    let photo = photoImageView.image
    let rating = ratingControl.rating
    meal = Meal.init(name: name, photo: photo, rating: rating)
  }

  @IBAction func cancel(_ sender: UIBarButtonItem) {
    // 遷移元のViewControllerから新規追加かどうかを判定
    let isPresentingInAddMealMode = presentingViewController is UINavigationController

    if isPresentingInAddMealMode {
      // 登録処理のキャンセル
      dismiss(animated: true, completion: nil)
    } else if let owningNavigationController = navigationController {
     // 更新処理のキャンセル
      owningNavigationController.popViewController(animated: true)
    } else {
      fatalError("The MealViewController is not inside a navigation controller.")
    }
  }

  //MARK: Actions
  @IBAction func selectImageFromPhotoLibraly(_ sender: UITapGestureRecognizer) {
    print("selectImageFromPhotoLibraly")
    // キーボードの非表示
    nameTextField.resignFirstResponder()
    // UIImagePickerControllerを使って、ユーザーの画像選択周りの処理を行う。
    let imagePickerController = UIImagePickerController()
    // カメラを起動せず、保存されたライブラリからのみ取得するようにする。
    imagePickerController.sourceType = .photoLibrary
    // 画像選択時にimagePickerControllerを呼び出す
    imagePickerController.delegate = self
    present(imagePickerController, animated: true, completion: nil)
  }

  // MARK: private Methods
  private func updateSaveButtonState() {
    // 食事の名前の入力状態からSaveButtonの活性/非活性を制御
    let text = nameTextField.text ?? ""
    SaveButton.isEnabled = !text.isEmpty
  }
}
