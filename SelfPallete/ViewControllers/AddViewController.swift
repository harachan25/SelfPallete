//
//  AddViewController.swift
//  selfpallete
//
//  Created by A .H on 2022/06/04.
//

import Foundation
import UIKit
import RealmSwift

class AddViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var goalTextField: UITextField!
    @IBOutlet var goalTextSaveButton: UIButton!
    @IBOutlet var colorButton1: UIButton!
    @IBOutlet var colorButton2: UIButton!
    @IBOutlet var colorButton3: UIButton!
    @IBOutlet var colorButton4: UIButton!
    @IBOutlet var colorButton5: UIButton!
    
    @IBOutlet var imageButton: UIButton!
    @IBOutlet var postTextField: UITextField!
    
    var flameColor = ""
    
    let realm = try! Realm()
    public var posts = [Post]()
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    //Viewの初期設定を行うメソッド
    func setUpViews(){
        colorButton1.backgroundColor = MyColor.pastelRed
        colorButton1.layer.cornerRadius = 27
        colorButton2.backgroundColor = MyColor.pastelYellow
        colorButton2.layer.cornerRadius = colorButton1.layer.cornerRadius
        colorButton3.backgroundColor = MyColor.pastelGreen
        colorButton3.layer.cornerRadius = colorButton1.layer.cornerRadius
        colorButton4.backgroundColor = MyColor.pastelBlue
        colorButton4.layer.cornerRadius = colorButton1.layer.cornerRadius
        colorButton5.backgroundColor = MyColor.pastelPurple
        colorButton5.layer.cornerRadius = colorButton1.layer.cornerRadius
        imageButton.layer.borderColor = UIColor.gray.cgColor
        imageButton.layer.borderWidth = 10
    }
    
    
    //キャンセルボタンを押したときのアクション
    @IBAction func didTapCancelButton(){
        self.dismiss(animated: true)
    }
    
    //ポストボタンを押したときのアクション
    @IBAction func didTapPostButton(){
        guard let _ = postTextField.text else{ return }

        savePost()
        self.dismiss(animated: true)
    }
    
    //目標設定
    @IBAction func goalTextSaveButtonAction(_ sender: Any) {
        userDefaults.set(goalTextField.text, forKey: "str")
        // ボタン押すとキーボードを閉じる
        goalTextField.endEditing(true)
    }
    
    //returnボタンを押したタイミングで起動
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //textField以外の部分のタッチ時にキーボード閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

//ダイアログ表示
//    override func viewDidAppear(_ animated: Bool) {
//      super.viewDidAppear(animated)
//      // ダイアログ(AlertControllerのインスタンス)を生成します
//      //   titleには、ダイアログの表題として表示される文字列を指定します
//      //   messageには、ダイアログの説明として表示される文字列を指定します
//      let dialog = UIAlertController(title: "投稿内容を入力してください", message: "", preferredStyle: .alert)
//      // 選択肢(ボタン)を2つ(OKとCancel)追加します
//      //   titleには、選択肢として表示される文字列を指定します
//      //   styleには、通常は「.default」、キャンセルなど操作を無効にするものは「.cancel」、削除など注意して選択すべきものは「.destructive」を指定します
//      dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//      // 生成したダイアログを実際に表示します
//      self.present(dialog, animated: true, completion: nil)
//    }
    
    //投稿を保存するメソッド
    func savePost() {
        guard let postText = postTextField.text else { return }

        let post = Post() //クラスPOSTのインスタンス生成
        post.postText = postText //投稿のテキストをセット
        
        let dt = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMdHm", options: 0, locale: Locale(identifier: "ja_JP"))
        post.postTime = dateFormatter.string(from: dt)
        
        //画像がボタンにセットされてたら画像も保存
        if let postImage = imageButton.backgroundImage(for: .normal){
            let imageURLStr = saveImage(image: postImage) //画像を保存
            post.imageFileName = imageURLStr
            post.flameColor = flameColor  //フレームの色保存
        }

        try! realm.write({
            realm.add(post) //レコードを追加
        })
    }
    
    
    
    //画像を保存するメソッド
    func saveImage(image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return nil }

        do {
            let fileName = UUID().uuidString + ".jpeg" // ファイル名を決定(UUIDは、ユニークなID)
            let imageURL = getImageURL(fileName: fileName) // 保存先のURLをゲット
            try imageData.write(to: imageURL) // imageURLに画像を書き込む
            return fileName
        } catch {
            print("Failed to save the image:", error)
            return nil
        }
    }
        // URLを取得するメソッド
            func getImageURL(fileName: String) -> URL {
                let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                return docDir.appendingPathComponent(fileName)
            }
    

        // 画像選択ボタンを押したときのアクション
        @IBAction func didTapImageButton() {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            present(imagePickerController, animated: true)
        }
       //色ボタンを押したときのアクション
        @IBAction func didTapColorButton1(){
            imageButton.layer.borderColor = colorButton1.backgroundColor?.cgColor
            flameColor = "ff7f7f"
        }
        @IBAction func didTapColorButton2(){
            imageButton.layer.borderColor = colorButton2.backgroundColor?.cgColor
            flameColor = "ffff7f"
        }
        @IBAction func didTapColorButton3(){
            imageButton.layer.borderColor = colorButton3.backgroundColor?.cgColor
            flameColor = "7fffbf"
        }
        @IBAction func didTapColorButton4(){
            imageButton.layer.borderColor = colorButton4.backgroundColor?.cgColor
            flameColor = "87cefa"
        }
        @IBAction func didTapColorButton5(){
            imageButton.layer.borderColor = colorButton5.backgroundColor?.cgColor
            flameColor = "bf7fff"
        }

    
}


extension AddViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // ライブラリから戻ってきた時に呼ばれるデリゲートメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return picker.dismiss(animated: true) }
        imageButton.setBackgroundImage(pickedImage, for: .normal) // imageViewのバックグラウンドに選択した画像をセット
        picker.dismiss(animated: true)
    }
}



class MyColor: UIColor {
    class public var pastelRed: UIColor {
            return UIColor(hex: "#ff7f7f")
    }
    class public var pastelYellow: UIColor {
            return UIColor(hex: "#ffff7f")
    }
    class public var pastelGreen: UIColor {
            return UIColor(hex: "#7fffbf")
    }
    class public var pastelBlue: UIColor {
            return UIColor(hex: "#87cefa")
    }
    class public var pastelPurple: UIColor {
            return UIColor(hex: "#bf7fff")
    }
}




extension UIColor {
    convenience init(hex: String) {
        // スペースや改行がはいっていたらトリムする
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        // 頭に#がついていたら取り除く
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        // RGBに変換する
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
