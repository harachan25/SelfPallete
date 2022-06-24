//
//  TimeLineViewController.swift
//  selfpallete
//
//  Created by A .H on 2022/06/03.
//

import UIKit
import RealmSwift

class TimeLineViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    
    let realm = try! Realm()
    public var posts = [Post]()
    let addv = AddViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        getgoalData()
        getPostData()
        collectionView.dataSource = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getgoalData()
        getPostData()
        collectionView.dataSource = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    //Viewの初期設定を行うメソッド
    func setUpViews() {
        tableView.delegate = self
        tableView.dataSource = self
    }
  
    //目標設定
    func getgoalData(){
        navigationItem.title = addv.userDefaults.string(forKey: "str")
    }

    //Realmからデータを取得してテーブルビューを再リロードするメソッド
    func getPostData(){
        posts = Array(realm.objects(Post.self)).reversed() // Realm DBから保存されてるツイートを全取得
        print(posts)
            tableView.reloadData() //テーブルビューをリロード
    }
    
}

extension TimeLineViewController: UICollectionViewDelegate,UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
//    //CollectionViewのセクション数
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//           return 1
//       }
    // CollectionViewが何個のCellを表示するのか設定するデリゲートメソッド
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    // ColorCellの中身を設定するメソッド
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
        cell.backgroundColor =  .blue
        return cell
    }
    

    // TableViewが何個のCellを表示するのか設定するデリゲートメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return posts.count
        }
    // PostCellの中身を設定するデリゲートメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        guard let postImageView = cell.viewWithTag(1) as? UIImageView,
              let postLabel = cell.viewWithTag(3) as? UILabel,
              let postTimeLabel = cell.viewWithTag(4) as? UILabel
        else { return cell }
        
        let post = posts[indexPath.row]
        postLabel.text = post.postText
        postTimeLabel.text = post.postTime
        
        
        if let imageFileName = post.imageFileName {
            let path = getImageURL(fileName: imageFileName).path // 画像のパスを取得
            if FileManager.default.fileExists(atPath: path) { // pathにファイルが存在しているかチェック
                if let imageData = UIImage(contentsOfFile: path) { // pathに保存されている画像を取得
                    postImageView.image = imageData
                    postImageView.layer.borderColor = UIColor.hex(post.flameColor, alpha: 0.9).cgColor
                    postImageView.layer.borderWidth = 10
                    postImageView.backgroundColor = UIColor.hex(post.flameColor, alpha: 0.5)
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
//スワイプでcell消去
    // セルの削除許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
                return true
            }
    // TableViewのCellの削除を行った際に、Realmに保存したデータを削除する
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive,
                                        title: "消去") { (action, view, completionHandler) in
            self.showAlert(deleteIndexPath: indexPath)
            completionHandler(true)
        }
        action.backgroundColor = .orange
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }

    func showAlert(deleteIndexPath indexPath: IndexPath) {
        let dialog = UIAlertController(title: "投稿の消去",
                                       message: "消しますか？",
                                       preferredStyle: .alert)

        dialog.addAction(UIAlertAction(title: "消す", style: .default, handler: { [self] (_) in
            let deletedItem = posts.remove(at: indexPath.row)
            
            try? self.realm.write {
                realm.delete(deletedItem)
            }
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
        }))
        dialog.addAction(UIAlertAction(title: "消さない", style: .cancel, handler: nil))
        self.present(dialog, animated: true, completion: nil)
    }
}
