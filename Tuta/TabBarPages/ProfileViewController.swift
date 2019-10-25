//
//  ProfileViewController.swift
//  Tuta
//
//  Created by Zhen Duan on 10/23/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class ProfileViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColorFromRGB(rgbValue: 0xd9eeec)
        addTitleLabel()
        addLogOutButton()
    }
    
    func addLogOutButton() {
        let logOutButton = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 42))
        logOutButton.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height * 4 / 5)
        logOutButton.setTitle("Log Out", for: UIControl.State.normal)
        logOutButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        logOutButton.setTitleColor(UIColor.gray, for: UIControl.State.selected)
        logOutButton.backgroundColor = UIColorFromRGB(rgbValue: 0xda9833)
        logOutButton.addTarget(self, action: #selector(logOutButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(logOutButton)
    }
    
    @objc func logOutButtonPressed(_ sender: UIButton!) {
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        print("logout successful")
        
        let sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "logInViewController") as LogInViewController
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func addTitleLabel() {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        titleLabel.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/3)
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.text = "This page shows user's profile."
        titleLabel.font = UIFont.systemFont(ofSize: 28.0)
        titleLabel.textColor = UIColorFromRGB(rgbValue: 0xda9833)
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
