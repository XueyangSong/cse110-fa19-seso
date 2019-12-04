//
//  ViewProfileViewController.swift
//  Tuta
//
//  Created by Alex Li on 11/16/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase
import MessageUI

private let darkBlueColor = UIColor(red:0.24, green:0.44, blue:0.64, alpha:1.0)
private let lightBlueColor = UIColor(red:0.85, green:0.93, blue:0.93, alpha:1.0)


class ViewProfileViewController: UIViewController,MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
            case .cancelled:
                print("Message was cancelled")
                dismiss(animated: true, completion: nil)
            case .failed:
                print("Message failed")
                dismiss(animated: true, completion: nil)
            case .sent:
                print("Message was sent")
                dismiss(animated: true, completion: nil)
            default:
            break
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    public var shouldShowRequest = true
    
    let dc = DataController()
    var user : TutaUser = TutaUser()
    var post : [String:Any]!
    var selfUser = TutaUser()
    var uid : String = Auth.auth().currentUser!.uid
    var userID = ""
    var imgUrl = ""
    var imagePicker = UIImagePickerController()
    var imageData = Data()
    let defaultProfile = Bundle.main.path(forResource: "stu-1", ofType: "jpg")

    @IBOutlet weak var ViewNameLabel: UILabel!
    
    @IBOutlet weak var ViewGenderLabel: UILabel!
    
    @IBOutlet weak var ViewRatingLabel: UILabel!
    
    @IBOutlet weak var ViewNumberRateLabel: UILabel!
    
    @IBOutlet weak var ViewEmailLabel: UILabel!
    
    @IBOutlet weak var ViewPhoneNumberLabel: UILabel!
    
    @IBOutlet weak var ViewDescriptionTextView: UITextView!
    
    @IBOutlet weak var ViewCoursesTakenLabel: UILabel!
    @IBOutlet weak var ViewPhotoImageView: UIImageView!
    @IBOutlet weak var RequestButton: UIButton!
    @IBOutlet weak var MessageMeButton: UIButton!
    let db = Firestore.firestore()
    
    let myFont = UIFont(name: "HelveticaNeue-Light", size: 20)!
    @IBAction func RequestButtonClicked(_ sender: Any) {
        //RequestButton.isEnabled = false
        var type = post?["type"] as? String
        var event = Event()
        let myFont = UIFont(name: "HelveticaNeue-Light", size: 20)!
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let date = formatter.string(from: Date())
        formatter.dateFormat = "hh:mm:ss"
        let time = formatter.string(from: Date())
        
        print(post?["creatorID"] as! String)
        print(uid)

        
        if(self.uid != self.post?["creatorID"] as! String){
            dc.getUserFromCloud(userID: uid){
                (u) in self.selfUser = u
                var isRequested : Bool = true
                if(type! == "tutor"){

                    event = Event(studentID: self.uid, tutorID: self.post?["creatorID"] as! String, time: time, date: date, course: self.post?["course"] as! String, status: "requested", studentName: self.selfUser.name, tutorName: self.post?["creatorName"] as! String, requesterID: self.uid)

                    
                    self.dc.ifRequestedBefore(event: event){ (b) in isRequested = (b)
                        if(isRequested){
                            self.showToast(message: "You have requested before", font: myFont)
                            print("requested before")
                            return;
                        }
                        else{
                            self.dc.uploadEventToCloud(event: event)
                            self.showToast(message: "Successfully requested", font: myFont)
                            print("success")
                        }
                    }
                }
                else{

                    event = Event(studentID: self.post?["creatorID"] as! String, tutorID: self.uid, time: time, date: date, course: self.post?["course"] as! String, status: "requested", studentName: self.post?["creatorName"] as! String, tutorName: self.selfUser.name, requesterID: self.uid)

                    self.dc.ifRequestedBefore(event: event){
                        (b) in isRequested = (b)
                        if(isRequested){
                            self.showToast(message: "You have requested before", font: myFont)
                            print("requested before")
                            return;
                        }
                        else{
                            self.showToast(message: "Successfully requested", font: myFont)
                            self.dc.uploadEventToCloud(event: event)
                        }
                    }
                }
            }
        }
        else{
            dc.deletePostCard(cardDic: post)
            self.showToast(message: "Successfully deleted", font: myFont)
        }
    }
    
    
    @IBAction func Message(_ sender: Any) {
        if MFMessageComposeViewController.canSendText() == false {
            print("Cannot send text")
            return
        }

            let controller = MFMessageComposeViewController()
        controller.body = "Hi " + user.name + ", "
            controller.recipients = [(self.ViewPhoneNumberLabel.text ?? "000")]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //dc.delegate = self
        setUpUI()
        
        userID = (post["creatorID"]as? String)!
        if(uid == userID){
            RequestButton.setTitle("delete", for: .normal)
            self.showProfile()
        }
        else{
            print("&*(^%^&*()(*^%$")
            var isRequested : Bool = true
            var type = post?["type"] as? String
            var event = Event()
            let myFont = UIFont(name: "HelveticaNeue-Light", size: 20)!
            let calendar = Calendar.current
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            let date = formatter.string(from: Date())
            formatter.dateFormat = "hh:mm:ss"
            let time = formatter.string(from: Date())
            
            
            dc.getUserFromCloud(userID: uid){
                (u) in self.selfUser = u
//                if(type! == "tutor"){
//
//                    event = Event(studentID: self.uid, tutorID: self.post?["creatorID"] as! String, time: time, date: date, course: self.post?["course"] as! String, status: "requested", studentName: self.selfUser.name, tutorName: self.post?["creatorName"] as! String, requesterID: self.uid)
//
//
//                    self.dc.ifRequestedBefore(event: event){ (b) in isRequested = (b)
//                        if(isRequested){
//                            self.RequestButton.isEnabled = false
//                            return
//                        }
//                        else{
//                            self.dc.deleteEvent(event: event)
//                        }
//                    }
//                }
//                else{
//
//                    event = Event(studentID: self.post?["creatorID"] as! String, tutorID: self.uid, time: time, date: date, course: self.post?["course"] as! String, status: "requested", studentName: self.post?["creatorName"] as! String, tutorName: self.selfUser.name, requesterID: self.uid)
//
//                    self.dc.ifRequestedBefore(event: event){
//                        (b) in isRequested = (b)
//                        if(isRequested){
//                            self.RequestButton.isEnabled = false
//                            return
//                        }
//                        else{
//                            self.dc.deleteEvent(event: event)
//                        }
//                    }
//                }
                self.showProfile()
            }
            
            
        }
    }
    
    func setUpUI() {
        self.view.backgroundColor = lightBlueColor
        
        ViewDescriptionTextView.backgroundColor = UIColor.clear
        
        RequestButton.backgroundColor = darkBlueColor
        RequestButton.setTitleColor(UIColor.white, for: .normal)
        RequestButton.titleLabel?.font = .systemFont(ofSize: 22)
        MessageMeButton.backgroundColor = darkBlueColor
        MessageMeButton.setTitleColor(UIColor.white, for: .normal)
        MessageMeButton.titleLabel?.font = .systemFont(ofSize: 18)
        
        if !shouldShowRequest {
            RequestButton.isHidden = true
        }
    }
    
    func showProfile(){
        self.dc.getUserFromCloud(userID: self.userID){(e) in self.user = (e)
            
            self.ViewNameLabel.text = self.user.name
            self.ViewEmailLabel.text = self.user.email
            self.ViewGenderLabel.text = self.user.gender
            self.ViewPhoneNumberLabel.text = self.user.phone
            self.ViewDescriptionTextView.text = self.user.description
            self.ViewDescriptionTextView.isEditable = false
            self.ViewRatingLabel.text = "rating: " + String(format: "%.02f", self.user.rating)
            print( "*^%^&*" + (self.ViewRatingLabel.text ?? "u"))
            self.ViewNumberRateLabel.text =  String(self.user.numRate) + " rates"
            var courses : String = ""
            for item in self.user.courseTaken{
                courses = courses + item + " "
            }
            self.ViewCoursesTakenLabel.text = courses
            self.imgUrl = self.user.url
            print("*********")
            print(self.imgUrl)
            if(self.imgUrl == ""){}
            else{
                self.imageData = try!Data(contentsOf: URL(string: self.imgUrl) ??  URL(fileURLWithPath: self.defaultProfile!))
                self.ViewPhotoImageView.image = UIImage(data : self.imageData)
            }
        }
    }
    
    func showToast(message : String, font: UIFont) {

           let rect = CGRect.init(x: (self.view.frame.width - 250) / 2, y: ViewDescriptionTextView.frame.origin.y - 55, width: 250, height: 35)
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


