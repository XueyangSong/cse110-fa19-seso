//
//  ChangeNumberController.swift
//  Tuta
//
//  Created by irene on 11/11/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase

class ChangeNumberController:UIViewController{
    
    let dc = DataController()
    //let profile = ProfileViewController()
    let userID = Auth.auth().currentUser?.uid
    var user:TutaUser = TutaUser()
    
    @IBOutlet weak var numberText: UITextField!
    
    
    @IBAction func saveNumber(_ sender: Any) {
        var user : TutaUser = TutaUser()
        dc.getUserFromCloud(userID: userID!){(e) in user = (e)
            user.phone = self.numberText.text!
            self.dc.uploadUserToCloud(tutaUser: user)
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dc.getUserFromCloud(userID: self.userID!){(e) in self.user = (e)
            self.numberText.text = self.user.phone
        }
//        numberText.delegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        numberText.resignFirstResponder()
    }
}

extension ChangeNumberController : UITextFieldDelegate{
//    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//        textView.resignFirstResponder()
//        return true
//    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}
