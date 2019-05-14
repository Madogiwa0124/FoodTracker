//
//  MealViewController
//  FoodTracker
//
//  Created by Madogiwa on 2019/03/09.
//  Copyright © 2019年 Apple Inc. All rights reserved.
//

import UIKit

class MealViewController: UIViewController,
                      UITextFieldDelegate,
                      UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate {
  // MARK: Properties
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var ratingControl: RatingControl!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Handle the text field’s user input through delegate callbacks.
    nameTextField.delegate = self
  }

  //MARK: UITextFieldDelegate
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // Hide the keyboard.
    textField.resignFirstResponder()
    return true
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
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
}
