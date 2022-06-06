//
//  AddViewController.swift
//  selfpallete
//
//  Created by A .H on 2022/06/04.
//

import Foundation
import UIKit
import RealmSwift

class AddViewController: UIViewController {
    @IBOutlet var colorButton1: UIButton!
    @IBOutlet var colorButton2: UIButton!
    @IBOutlet var colorButton3: UIButton!
    @IBOutlet var colorButton4: UIButton!
    @IBOutlet var colorButton5: UIButton!
    @IBOutlet var backgroundColorLabel: UILabel!
    
    @IBOutlet var imageButton: UIButton!
    @IBOutlet var postTextField: UITextField!
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    //Viewの初期設定を行うメソッド
    func setUpViews(){
        imageButton.backgroundColor = .gray //その後指定した成長の色と対応させる
        colorButton1.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        colorButton1.layer.cornerRadius = 27
        colorButton2.backgroundColor = UIColor(red: 1, green: 1, blue: 0, alpha: 1)
        colorButton2.layer.cornerRadius = 27
        colorButton3.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
        colorButton3.layer.cornerRadius = 27
        colorButton4.backgroundColor = UIColor(red: 0, green: 1, blue: 1, alpha: 1)
        colorButton4.layer.cornerRadius = 27
        colorButton5.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
        colorButton5.layer.cornerRadius = 27
        backgroundColorLabel.backgroundColor = .gray
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
    
    
    //色ボタンを押したときのアクション
    @IBAction func didTapColorButton1(){
        backgroundColorLabel.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        
    }
    @IBAction func didTapColorButton2(){
        backgroundColorLabel.backgroundColor = UIColor(red: 1, green: 1, blue: 0, alpha: 0.5)
        
    }
    @IBAction func didTapColorButton3(){
        backgroundColorLabel.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
        
    }
    @IBAction func didTapColorButton4(){
        backgroundColorLabel.backgroundColor = UIColor(red: 0, green: 1, blue: 1, alpha: 0.5)
        
    }
    @IBAction func didTapColorButton5(){
        backgroundColorLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
        
    }
    
    
    
    
    //投稿を保存するメソッド
    func savePost() {
        guard let postText = postTextField.text else { return }

        let post = Post()
        post.postText = postText //投稿のテキストをセット
        
        //画像がボタンにセットされてたら画像も保存
        if let postImage = imageButton.backgroundImage(for: .normal){
            let imageURLStr = saveImage(image: postImage) //画像を保存
            post.imageFileName = imageURLStr
        }

        try! realm.write({
            realm.add(post) //レコードを追加
        })
        
    }
    
    
    
    //画像を保存するメソッド
    func saveImage(image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return nil }

        do {
            _ = imageButton.backgroundColor
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
    
}


extension AddViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // ライブラリから戻ってきた時に呼ばれるデリゲートメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return picker.dismiss(animated: true) }
        imageButton.setBackgroundImage(pickedImage, for: .normal) // imageViewのバックグラウンドに選択した画像をセット
        picker.dismiss(animated: true)
    }
}



