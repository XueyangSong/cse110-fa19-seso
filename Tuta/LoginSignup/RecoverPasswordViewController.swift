//
//  RecoverPasswordViewController.swift
//  Tuta
//
//  Created by Alex Li on 11/29/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//



import UIKit
import Firebase
import FirebaseAuth





class RecoverPasswordViewController: UIViewController{

    



    @IBOutlet weak var userEmailTextField: UITextField!
    override public func viewDidLoad() {

        super.viewDidLoad()

    }

    @IBAction func RecoverPasswordTapped(_ sender: Any) {
        let userEmail = self.userEmailTextField.text

        

        Auth.auth().sendPasswordReset(withEmail: userEmail!, completion: { (error) in

            if error != nil{

                let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)

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
