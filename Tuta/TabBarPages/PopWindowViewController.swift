//
//  PopWindowViewController.swift
//  Tuta
//
//  Created by JIAHE LIU on 11/18/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class PopWindowViewController: UIViewController{

    
    @IBOutlet weak var typeSegment: UISegmentedControl!
    
    @IBOutlet weak var courseField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    let myFont = UIFont(name: "HelveticaNeue-Light", size: 20)!
    let dc = DataController()
    let uid = Auth.auth().currentUser?.uid
    var user = TutaUser()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.applyButton()
        setUpTapGesture()
        view.backgroundColor = UIColor(red:0.85, green:0.93, blue:0.93, alpha:1.0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterForKeyboardNorifications()
    }
    
    func setUpTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    func showToast(message : String, font: UIFont) {

        let rect = CGRect.init(x: (self.view.frame.width - 250) / 2, y: courseField.frame.origin.y + 55, width: 250, height: 35)
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
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
    }

    @objc func keyboardWillHide(notification: Notification) {
        self.view.frame.origin.y = 0
    }

    func deregisterForKeyboardNorifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        if isFieldsValid()!{
            let segmentText = self.typeSegment.titleForSegment(at: self.typeSegment.selectedSegmentIndex) as! String
            let type = segmentText.lowercased()
            
            let courseString = self.courseField.text!.lowercased()
            let course = String(courseString.filter{!$0.isNewline && !$0.isWhitespace})
            print(courseString)
            print(course)
            
            
            let description = self.descriptionField.text!
            let cardID = dc.getNewCardID(type: type, course: course)
            //dc.getUserFromCloud(userID: self.userID!){(e) in self.user = (e)
            let calendar = Calendar.current
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            let date = formatter.string(from: Date())
            
            formatter.dateFormat = "hh:mm:ss"
            let time = formatter.string(from: Date())
            
            dc.getUserFromCloud(userID: self.uid!){(u) in self.user = (u)
                let card = PostCard(creatorID: self.user.uid, creatorName: self.user.name, description: description, date: date, time: time, cardID: cardID, course: course, type: type, rating: self.user.rating, numRate: self.user.numRate, creatorURL: self.user.url)
                
                //dc.getUserFromCloud(userID: self.userID!){(e) in self.user = (e)}
                var isSuccess = false
                self.dc.uploadCardToCloud(postCard: card){
                    (b) in isSuccess = (b)
                    if isSuccess{
                        self.showToast(message: "Successfully posted!", font: self.myFont)
                        self.descriptionField.text = ""
                        self.courseField.text = ""
                    }
                    else{
                        self.showToast(message: "Post already exists!", font: self.myFont)
                    }
                }
                
            }
            
        }else{
            showToast(message: "Please fill in every field", font: myFont)
        }
    }
    
    func isFieldsValid()->Bool?{
        // check empty fields
        if courseField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
           descriptionField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return false
        }
        
        return true
    }
    
    
}



extension UIButton{
    func applyButton(){
        self.layer.cornerRadius = self.frame.height / 2
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
