//
//  EnoguUILabel.swift
//  SelfPallete
//
//  Created by A .H on 2022/06/13.
//

import UIKit

class CustomView: UIView {

}
class EnoguViewController: UIViewController {
    // flameView: 角丸
    private lazy var flameView: UIView = {
        let flameView = UIView()
        flameView.clipsToBounds = true
        flameView.layer.cornerRadius = 15
        return flameView
    }()
    // shadowView: 影
    private lazy var shadowView: UIView = {
        let shadowView = UIView()
        shadowView.layer.shadowColor = UIColor.hex("a58f86", alpha: 1).cgColor
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowRadius = flameView.layer.cornerRadius
        shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        return shadowView
    }()
//
//    override func loadView() {
//        shadowView.addSubview(flameView)
//        self.view = shadowView
//    }
}
