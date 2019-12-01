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
    @IBOutlet weak var save: UIButton!
    
    
    @IBOutlet weak var AddCourseTextField: UITextField!
    
    @IBAction func confirmAddButton(_ sender: Any) {
        var user : TutaUser = TutaUser()
         dc.getUserFromCloud(userID: userID!){(e) in user = (e)
            user.courseTaken.append(self.AddCourseTextField.text!) 
            self.dc.uploadUserToCloud(tutaUser: user)
         }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerForKeyboardNotifications()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        save.applyButton()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterForKeyboardNotifications()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        AddCourseTextField.resignFirstResponder()
    }
    
    func setUp() {
        let tap = UITapGestureRecognizer (target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func deregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
//        if let keyboardFrame : NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardY = keyboardRectangle.origin.y
//
//            if activeField != nil {
//                distance = keyboardY - (activeField?.frame.origin.y)! - (activeField?.frame.height)! * 2 - self.view.frame.origin.y
//                //print(distance!)
//                if (distance.isLess(than: CGFloat.zero)) {
//                    self.view.frame.origin.y += distance
//                    //print("screen moved")
//                }
//            }
//        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        self.view.frame.origin.y = 0
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

