//
//  SignUpViewController.swift
//  This Is Nothing
//
//  Created by Zhen Duan on 10/19/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    var activeField: UITextField?
    var distance: CGFloat? = 0
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpDelegate()
        registerForKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        deregisterForKeyboardNotification()
    }

    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        trySignUp()
    }
    
    func setUp() {
        // set tap dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
    }
    
    // *** delegate
    func setUpDelegate() {
        // add text field delegate
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // *** key board notification ***
    
    func registerForKeyboardNotifications() {
        // add keyboard notification observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWilShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWilHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func deregisterForKeyboardNotification() {
        // remove keyboard notification observers
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // *** textField ***
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //print("begin editing")
        activeField = textField
        //print(activeField?.placeholder ?? "")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //print("end editing")
        if textField == emailTextField || textField == nameTextField {
            if emailTextField.text != "" && nameTextField.text != "" {
                passwordTextField.isUserInteractionEnabled = true
            }
        }
        activeField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //print("done button clicked")
        self.view.endEditing(true)
        return true
    }
    
    // *** sign up ***
    
    func trySignUp() {
        let name = nameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        
        print(name ?? "")
        print(email ?? "")
        print(password ?? "")
    }
    
    // *** objective-c functions ***
    
    @objc func keyboardWilShow(notification: Notification) {
        //print("Keyboard will show called")
        if let keyboardFrame : NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardY = keyboardRectangle.origin.y
            
            if activeField != nil {
                distance = keyboardY - (activeField?.frame.origin.y)! - (activeField?.frame.height)! * 2 - self.view.frame.origin.y
                //print(distance!)
                if (distance?.isLess(than: CGFloat.zero))! {
                    self.view.frame.origin.y += distance!
                    //print("screen moved")
                }
            }
        }
    }
    
    @objc func keyboardWilHide(notification: Notification) {
        //print("Keyboard will hide called")
        
        self.view.frame.origin.y = 0
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
