//
//  TimeLineViewController.swift
//  selfpallete
//
//  Created by A .H on 2022/06/03.
//

import UIKit
import RealmSwift

class TimeLineViewController: UIViewController {
    @IBOutlet var palleteLabel: UILabel!
    @IBOutlet var yubiLabel: UILabel!
    @IBOutlet var enoguLabel1: UILabel!
    @IBOutlet var enoguLabel2: UILabel!
    @IBOutlet var enoguLabel3: UILabel!
    @IBOutlet var enoguLabel4: UILabel!
    @IBOutlet var enoguLabel5: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    let realm = try! Realm()
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        getPostData()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPostData()
    }
    
    //Viewの初期設定を行うメソッド
    func setUpViews() {
        tableView.delegate = self
        tableView.dataSource = self
        
        palleteLabel.backgroundColor = .systemGray5
        palleteLabel.layer.cornerRadius = 200
        yubiLabel.backgroundColor = .white
        yubiLabel.layer.cornerRadius = 25
        
        enoguLabel1.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        enoguLabel1.layer.cornerRadius = 20
        enoguLabel2.backgroundColor = UIColor(red: 1, green: 1, blue: 0, alpha: 1)
        enoguLabel2.layer.cornerRadius = 30
        enoguLabel3.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
        enoguLabel3.layer.cornerRadius = 40
        enoguLabel4.backgroundColor = UIColor(red: 0, green: 1, blue: 1, alpha: 1)
        enoguLabel4.layer.cornerRadius = 50
        enoguLabel5.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
        enoguLabel5.layer.cornerRadius = 60
    }

    //Realmからデータを取得してテーブルビューを再リロードするメソッド
    func getPostData(){
        posts = Array(realm.objects(Post.self)).reversed() // Realm DBから保存されてるツイートを全取得
        print(posts)
            tableView.reloadData() //テーブルビューをリロード
    }
    
}

extension TimeLineViewController: UITableViewDelegate, UITableViewDataSource {
    // TableViewが何個のCellを表示するのか設定するデリゲートメソッド
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return posts.count
        }
    // Cellの中身を設定するデリゲートメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        guard let postLabel = cell.viewWithTag(3) as? UILabel,
              let postImageView = cell.viewWithTag(4) as? UIImageView else { return cell }
        
        let post = posts[indexPath.row]
        postLabel.text = post.postText
        
        if let imageFileName = post.imageFileName {
            let path = getImageURL(fileName: imageFileName).path // 画像のパスを取得
            if FileManager.default.fileExists(atPath: path) { // pathにファイルが存在しているかチェック
                if let imageData = UIImage(contentsOfFile: path) { // pathに保存されている画像を取得
                    postImageView.image = imageData
                } else {
                    print("Failed to load the image. path = ", path)
                }
            } else {
                print("Image file not found. path = ", path)
            }
        }
        return cell
    }
       // URLを取得するメソッド
       func getImageURL(fileName: String) -> URL {
           let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
           return docDir.appendingPathComponent(fileName)
       }

       // Cellのサイズを設定するデリゲートメソッド
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           let post = posts[indexPath.row]
           return post.imageFileName == nil ? 90 : 310
       }
}
