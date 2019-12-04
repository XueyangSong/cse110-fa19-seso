//
//  ChangePasswordViewController.swift
//  Tuta
//
//  Created by Alex Li on 12/2/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth

class ChangePasswordViewController: UIViewController {
    
    
    @IBOutlet weak var userEmailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addSubview(backButton)
        backButton.anchor(top: self.view.topAnchor, left: self.view.leftAnchor,
                          paddingTop: 48, paddingLeft: 16, width: 32, height: 32)

    }
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "backIcon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(getBack), for: .touchUpInside)
        return button
    }()
    
    @objc func getBack() {
        let sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "HomeTabBarController") as HomeTabBarController
        vc.indexOfVcToBeDisplay = 2
        vc.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func ChangePasswordTapped(_ sender: Any) {
        let userEmail = self.userEmailTextField.text

        

        Auth.auth().sendPasswordReset(withEmail: userEmail!, completion: { (error) in

            if error != nil{

                let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error!.localizedDescription))", preferredStyle: .alert)

                resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                self.present(resetFailedAlert, animated: true, completion: nil)

            }else {

                let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully",message: "Check your email", preferredStyle: .alert)

                resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                self.present(resetEmailSentAlert, animated: true, completion: nil)

            }

        })
    }
   
}
