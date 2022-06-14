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

        if  imageButton.backgroundImage(for: .normal) == nil{
            let dialog = UIAlertController(title: "画像を設定してください", message: "", preferredStyle: .alert)
                              dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                              self.present(dialog, animated: true, completion: nil)
        }else if imageButton.layer.borderColor == UIColor.gray.cgColor {
            let dialog = UIAlertController(title: "色を選択してください", message: "", preferredStyle: .alert)
                              dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                              self.present(dialog, animated: true, completion: nil)
        }else{
            savePost()
            self.dismiss(animated: true)
        }
    }
    
    //目標設定
    @IBAction func goalTextSaveButtonAction(_ sender: Any) {
        userDefaults.set(goalTextField.text, forKey: "str")
        // ボタン押すとキーボードを閉じる
        goalTextField.endEditing(true)
        //ダイアログ表示
        let dialog = UIAlertController(title: "Saved!", message: "", preferredStyle: .alert)
                          self.present(dialog, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            dialog.dismiss(animated: true, completion: nil)
        }
    }
    //textField以外の部分のタッチ時にキーボード閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //投稿を保存するメソッド
    func savePost() {
        guard let postText = postTextField.text else { return }

        let post = Post() //クラスPostのインスタンス生成
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
        imageButton.setBackgroundImage(pickedImage, for: .normal) // imageButtonのバックグラウンドに選択した画像をセット
        imageButton.layoutIfNeeded()
        imageButton.subviews.first?.contentMode = .scaleAspectFit // 余白消すなら.scaleAspectFill
        picker.dismiss(animated: true)
        print(imageButton.backgroundImage)
    }
}
