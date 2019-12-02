//
//  LogInViewController.swift
//  This Is Nothing
//
//  Created by Zhen Duan on 10/20/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class LogInViewController: UIViewController, UITextFieldDelegate {
    var activeField : UITextField?
    var distance : CGFloat = 0
    let myFont = UIFont(name: "HelveticaNeue-Light", size: 20)!
    var loginClicked = false

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        tryLogIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setUpDelegate()
        
        registerForKeyboardNotifications()
        
        if (SignUpViewController.firstSignUp == 1) {
            showToastForSignUp()
            SignUpViewController.firstSignUp = 0
            print ("toast for sign up")
        }
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
        /*
        let signUpVC = storyboard?.instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
        signUpVC.signUpDelegate = self*/
    }

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func deregisterForKeyboardNorifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
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

    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPattern = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPattern.evaluate(with: emailStr)
    }
    
    // show a toast
    func showToast(message : String, font: UIFont) {

        let rect = CGRect.init(x: (self.view.frame.width - 250) / 2, y: emailTextField.frame.origin.y - 65, width: 250, height: 35)
        let toastLabel = UILabel(frame: rect)
        
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 6.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showToastForSignUp() {
        showToast(message: "verification email sent", font: self.myFont)
    }
    
   
    // *** Log In ***
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tryLogIn() {
        if loginClicked{
            return
        }
        else{
            loginClicked = true
        }
        
        let email = emailTextField.text
        let password = passwordTextField.text
        Auth.auth().signIn(withEmail: email!, password: password!) { [weak self] user, error in
                  // [START_EXCLUDE]
            if error != nil {
                print("login failed")
                self!.showAlert(title: "Login Failed", message: error!.localizedDescription)
                self!.loginClicked = false
                return
            }
            else{
                if(!Auth.auth().currentUser!.isEmailVerified){
                    // alert for verifying email
                    self!.showAlert(title: "Please verify your email", message: "We've sent an email to \(email!)")
                    self!.loginClicked = false
                    return
                }
                print("login successfull")
                    
                UserDefaults.standard.set(true, forKey: "userLoggedIn")
                    
                // present home tabBarController
                let sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(identifier: "HomeTabBarController") as HomeTabBarController
                vc.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
                vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                self!.present(vc, animated: true, completion: nil)
            }
        }
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

/*
extension LogInViewController: SignUpDelegate{
    func didReceiveData(value: String) {
        showToast(message: value, font: myFont)
    }
}
*/
