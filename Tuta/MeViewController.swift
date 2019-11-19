//
//  MainProfileViewController.swift
//  Tuta
//
//  Created by JIAHE LIU on 11/18/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit

class MeViewController: UIViewController {
    @IBOutlet weak var Profile: UIButton!
    @IBOutlet weak var Event: UIButton!
    @IBOutlet weak var Setting: UIButton!
    @IBOutlet weak var Logout: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Profile.apply()
        Event.apply()
        Setting.apply()
        Logout.apply()
        // Do any additional setup after loading the view.
    }
}
extension UIButton{
    func apply(){
        self.backgroundColor = UIColor.darkGray
        self.layer.cornerRadius = self.frame.height / 2
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
