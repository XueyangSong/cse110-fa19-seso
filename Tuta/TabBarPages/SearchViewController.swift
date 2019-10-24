//
//  SearchViewController.swift
//  Tuta
//
//  Created by Zhen Duan on 10/23/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColorFromRGB(rgbValue: 0x64b2cd)
        addTitleLabel()
    }
    
    func addTitleLabel() {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        titleLabel.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/3)
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.text = "User can search for courses in this page."
        titleLabel.font = UIFont.systemFont(ofSize: 28.0)
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 3
        self.view.addSubview(titleLabel)
        
    }
        
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
