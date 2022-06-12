//
//  CustomColor.swift
//  SelfPallete
//
//  Created by A .H on 2022/06/13.
//

import UIKit

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
    class func hex (_ hexStr : String, alpha : CGFloat) -> UIColor {
        var hexStr = hexStr
        let alpha = alpha
        hexStr = hexStr.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hexStr)
        var color: UInt64 = 0
        if scanner.scanHexInt64(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            return UIColor.white
        }
    }
}

