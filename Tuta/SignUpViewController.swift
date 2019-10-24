//
//  SignUpViewController.swift
//  This Is Nothing
//
//  Created by Zhen Duan on 10/19/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    var activeField: UITextField?
    var distance: CGFloat? = 0
    let myFont = UIFont (name: "TimesNewRomanPS-BoldMT", size: 15)
    
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
    
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPattern = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPattern.evaluate(with: emailStr)
    }
    
    // show a toast
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 120, y: self.view.frame.size.height-100, width: 250, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    // check if each field is valid
    func isFieldsValid()->Bool?{
        // check empty fields
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
           emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            showToast(message: "Please fill in every field", font: myFont!)
            return false
        }
        
        // check email pattern
        let email = emailTextField.text;
        if !isValidEmail(emailStr: email!){
            showToast(message: "Please enter a valid email", font: myFont!)
            return false
        }
        
        // check password length
        let password = passwordTextField.text;
        if password!.count < 8{
            showToast(message: "Password is too short", font: myFont!)
            return false
        }
        
        return true
    }
    
    func showToastForRegisteredEmail() {
        showToast(message: "This email has arealdy registered", font: myFont!)
    }
    // *** sign up ***
    
    func trySignUp() {
        let isValid = isFieldsValid()
        let email = emailTextField.text
        let password = passwordTextField.text
        if isValid!{
            Auth.auth().createUser(withEmail: email!, password: password!) { authResult, error in
              // [START_EXCLUDE]
                guard let user = authResult?.user, error == nil else {
                    self.showToastForRegisteredEmail()
                  print("failed")
                  return
                }
                // @TODO Go to login page
                print("\(user.email!) created")
                // jump to login page
                print("presenting logInViewController")
                let sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(identifier: "logInViewController") as LogInViewController
                vc.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
                vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                self.present(vc, animated: true, completion: nil)
                
              }
              // [END_EXCLUDE]
        }
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
