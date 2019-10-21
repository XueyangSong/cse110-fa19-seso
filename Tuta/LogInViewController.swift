//
//  LogInViewController.swift
//  This Is Nothing
//
//  Created by Zhen Duan on 10/20/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    var activeField : UITextField?
    var distance : CGFloat = 0
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        tryLogIn()
    }
    
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

        deregisterForKeyboardNorifications()
    }

    func setUp() {
        // add tap dismiss keyboard
        let tap = UITapGestureRecognizer (target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }

    func setUpDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func deregisterForKeyboardNorifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            if emailTextField.text != "" {
                passwordTextField.isUserInteractionEnabled = true
            } else {
                passwordTextField.isUserInteractionEnabled = false
                passwordTextField.text = ""
            }
        }
        activeField = nil
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if textField == passwordTextField {
            tryLogIn()
        }
        return true
    }

    // *** Log In ***

    func tryLogIn() {
        let email = emailTextField.text
        let password = passwordTextField.text

        print(email ?? "")
        print(password ?? "")
    }


    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame : NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardY = keyboardRectangle.origin.y

            if activeField != nil {
                distance = keyboardY - (activeField?.frame.origin.y)! - (activeField?.frame.height)! * 2 - self.view.frame.origin.y
                //print(distance!)
                if (distance.isLess(than: CGFloat.zero)) {
                    self.view.frame.origin.y += distance
                    //print("screen moved")
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
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
