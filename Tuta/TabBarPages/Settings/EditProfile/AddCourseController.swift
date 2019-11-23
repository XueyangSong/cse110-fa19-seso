//
//  AddCourseController.swift
//  Tuta
//
//  Created by Alex Li on 11/7/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase


class AddCourseController:UIViewController {

    let dc = DataController()
    let userID = Auth.auth().currentUser?.uid
    
    
    @IBOutlet weak var AddCourseTextField: UITextField!
    
    @IBAction func confirmAddButton(_ sender: Any) {
        var user : TutaUser = TutaUser()
         dc.getUserFromCloud(userID: userID!){(e) in user = (e)
            user.courseTaken.append(self.AddCourseTextField.text!) 
            self.dc.uploadUserToCloud(tutaUser: user)
         }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let userID = Auth.auth().currentUser?.uid

//        print(type(of: DescriptionTextView))
//        print(type(of: self))
        //DescriptionButton.backgroundColor = ;
    }

//    @IBAction func EnterTapped(_ sender: Any) {
////        let userID = Auth.auth().currentUser?.uid
//        var user : TutaUser = TutaUser()
//        dc.getUserFromCloud(userID: userID!){(e) in user = (e)
//            user.description = self.DescriptionTextView.text!
//            self.dc.uploadUserToCloud(tutaUser: user, userId: self.userID!)
//        }
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        AddCourseTextField.resignFirstResponder()
    }
}

extension AddCourseController : UITextFieldDelegate{
//    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//        textView.resignFirstResponder()
//        return true
//    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}

