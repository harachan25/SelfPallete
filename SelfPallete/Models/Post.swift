//
//  Tweet.swift
//  selfpallete
//
//  Created by A .H on 2022/06/04.
//

import Foundation
import RealmSwift


class Post: Object {
    @objc dynamic var postText: String = ""
    @objc dynamic var imageFileName: String?
    //時間
}

