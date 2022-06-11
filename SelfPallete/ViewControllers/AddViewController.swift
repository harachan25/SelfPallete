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
//    let tim = TimeLineViewController()
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
        colorButton2.layer.cornerRadius = 27
        colorButton3.backgroundColor = MyColor.pastelGreen
        colorButton3.layer.cornerRadius = 27
        colorButton4.backgroundColor = MyColor.pastelBlue
        colorButton4.layer.cornerRadius = 27
        colorButton5.backgroundColor = MyColor.pastelPurple
        colorButton5.layer.cornerRadius = 27
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
//        UserDefaults.standard.set(goalTextField.text, forKey: "str")
//            let nextView = self.storyboard?.instantiateViewController(withIdentifier: "Next") as! TimeLineViewController
//            self.navigationController?.pushViewController(nextView, animated: true)
        }
    
    
    //投稿を保存するメソッド
    func savePost() {
        guard let postText = postTextField.text else { return }

        let post = Post() //クラスPOSTのインスタンス生成
        post.postText = postText //投稿のテキストをセット
        
//        // キーボードを閉じる
//        postTextField.resignFirstResponder()
        
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
            imageButton.backgroundColor = colorButton1.backgroundColor
            flameColor = "ff7f7f"
        }
        @IBAction func didTapColorButton2(){
            imageButton.layer.borderColor = colorButton2.backgroundColor?.cgColor
            imageButton.backgroundColor = colorButton2.backgroundColor
            flameColor = "ffff7f"
        }
        @IBAction func didTapColorButton3(){
            imageButton.layer.borderColor = colorButton3.backgroundColor?.cgColor
            imageButton.backgroundColor = colorButton3.backgroundColor
            flameColor = "7fffbf"
        }
        @IBAction func didTapColorButton4(){
            imageButton.layer.borderColor = colorButton4.backgroundColor?.cgColor
            imageButton.backgroundColor = colorButton4.backgroundColor
            flameColor = "7f7fff"
        }
        @IBAction func didTapColorButton5(){
            imageButton.layer.borderColor = colorButton5.backgroundColor?.cgColor
            imageButton.backgroundColor = colorButton5.backgroundColor
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
            return UIColor(hex: "#7f7fff")
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
