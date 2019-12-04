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
    let myFont = UIFont(name: "HelveticaNeue-Light", size: 20)!
    
    @IBOutlet weak var numberText: UITextField!
    
    
    @IBOutlet weak var save: UIButton!
    @IBAction func saveNumber(_ sender: Any) {
        var user : TutaUser = TutaUser()
        let isValid = isFieldValid()
        
        if isValid! {
            dc.getUserFromCloud(userID: userID!){(e) in user = (e)
                user.phone = self.numberText.text!
                self.dc.uploadUserToCloud(tutaUser: user)
            }
        }
    }
    
    // Check validity for phone. Print the toast if necessary.
    func isFieldValid()->Bool?{
        let phoneNum = self.numberText.text!
        if !isValidPhoneNum(numString: phoneNum){
            showToast(message: "Please enter a valid phone number", font:myFont)
            
            return false
        }
        
        return true
    }
    
    // Return true if only containing digits.
    func isValidPhoneNum(numString:String) -> Bool {
        let numRegEx = "[0-9]{9,15}"
        
        let numPattern = NSPredicate(format: "SELF MATCHES %@", numRegEx)
        return numPattern.evaluate(with: numString)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        dc.getUserFromCloud(userID: self.userID!){(e) in self.user = (e)
            self.numberText.text = self.user.phone
        }
        save.applyButton()
//        numberText.delegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        numberText.resignFirstResponder()
    }
    
    func showToast(message : String, font: UIFont) {

        let rect = CGRect.init(x: (self.view.frame.width - 250) / 2, y: numberText.frame.origin.y - 55, width: 250, height: 35)
        let toastLabel = UILabel(frame: rect)
            //CGRect(x: self.view.frame.size.width/2 - 120, y: self.view.frame.size.height-100, width: 250, height: 35))
        
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = .systemFont(ofSize: 20)
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds = true
        
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 1, delay: 2.5, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
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
