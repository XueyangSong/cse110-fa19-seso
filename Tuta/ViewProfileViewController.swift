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

class ViewProfileViewController: UIViewController{
    var save = false
    /* 尝试合并Me page和这个page
       lazy var containerView: UIView = {
           let view = UIView()
           var imgUrl = ""
           var imageData = Data()
           
           
           view.backgroundColor = .mainBlue
           
           view.addSubview(profileImageView)
           profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           profileImageView.anchor(top: view.topAnchor, paddingTop: 88,
                                   width: 120, height: 120)
           profileImageView.layer.cornerRadius = 120 / 2
           
           view.addSubview(backButton)
           backButton.anchor(top: view.topAnchor, left: view.leftAnchor,
                                paddingTop: 64, paddingLeft: 32, width: 32, height: 32)
           
           view.addSubview(followButton)
           followButton.anchor(top: view.topAnchor, right: view.rightAnchor,
                                paddingTop: 64, paddingRight: 32, width: 32, height: 32)
           
           view.addSubview(nameLabel)
           nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           nameLabel.anchor(top: profileImageView.bottomAnchor, paddingTop: 12)
           
           view.addSubview(emailLabel)
           emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           emailLabel.anchor(top: nameLabel.bottomAnchor, paddingTop: 4)
           

           return view
       }()

       
       let profileImageView: UIImageView = {
           let iv = UIImageView()
           iv.image = #imageLiteral(resourceName: "profilePic_1")
           iv.contentMode = .scaleAspectFill
           iv.clipsToBounds = true
           iv.layer.borderWidth = 3
           iv.layer.borderColor = UIColor.white.cgColor
           return iv
       }()
       
       let backButton: UIButton = {
           let button = UIButton(type: .system)
           button.setImage(#imageLiteral(resourceName: "backIcon").withRenderingMode(.alwaysOriginal), for: .normal)
           return button
       }()
       
       let followButton: UIButton = {

           let button = UIButton(type: .system)
           button.setImage(#imageLiteral(resourceName: "lightbulb").withRenderingMode(.alwaysOriginal), for: .normal)
           button.addTarget(self, action: #selector(handleMessageUser), for: .touchUpInside)

           return button
       }()
       
       let nameLabel: UILabel = {
           let label = UILabel()
           label.textAlignment = .center
           label.text = "Jason Chen"
           label.font = UIFont.boldSystemFont(ofSize: 26)
           label.textColor = .white
           return label
       }()
       
       let emailLabel: UILabel = {
           let label = UILabel()
           label.textAlignment = .center
           label.text = "xxxx@ucsd.edu"
           label.font = UIFont.systemFont(ofSize: 18)
           label.textColor = .white
           return label
       }()
       
       @objc func handleMessageUser() {

           //self.present(vc, animated: true, completion: nil)
       }
       // MARK: - Lifecycle

       
       override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
       }
       
    */
    
    
    
    let dc = DataController()
    var user : TutaUser = TutaUser()
    var post : [String:Any]!
    
    var uid = Auth.auth().currentUser?.uid
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
    let db = Firestore.firestore()
    
    let myFont = UIFont(name: "HelveticaNeue-Light", size: 20)!
    @IBAction func RequestButtonClicked(_ sender: Any) {
        RequestButton.isEnabled = false
        var type = post?["type"] as? String
        var event : Event
        let myFont = UIFont(name: "HelveticaNeue-Light", size: 20)!
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let date = formatter.string(from: Date())
        formatter.dateFormat = "hh:mm:ss"
        let time = formatter.string(from: Date())
        
        print(post?["creatorID"] as! String)
        print(uid)
        var isRequested : Bool = true
        if(type! == "tutor"){
            event = Event(studentID: self.uid!, tutorID: post?["creatorID"] as! String, time: time, date: date, course: post?["course"] as! String, status: "requested")
            
            dc.ifRequestedBefore(event: event){ (b) in isRequested = (b)
                if(isRequested){
                    self.showToast(message: "You have requested before", font: myFont)
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
            event = Event(studentID: post?["creatorID"] as! String, tutorID: self.uid!, time: time, date: date, course: post?["course"] as! String, status: "requested")
            dc.ifRequestedBefore(event: event){
                (b) in isRequested = (b)
                if(isRequested){
                    self.showToast(message: "You have requested before", font: myFont)
                    return;
                }
                else{
                    self.showToast(message: "Successfully requested", font: myFont)
                    self.dc.uploadEventToCloud(event: event)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ViewPhoneNumberLabel.text = self.user.phone
        
    }
    override func loadView() {
        super.loadView()
        /*
        view.backgroundColor = .white
                
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor,
                                     right: view.rightAnchor, height: 300)*/
        dc.delegate = self
        userID = (post["creatorID"]as? String)!
        dc.getUserFromCloud(userID: self.userID){(e) in self.user = (e)
            
            self.ViewNameLabel.text = self.user.name
            self.ViewEmailLabel.text = self.user.email
            self.ViewGenderLabel.text = self.user.gender
            self.ViewPhoneNumberLabel.text = self.user.phone
            self.ViewDescriptionTextView.text = self.user.description
            self.ViewRatingLabel.text = "rating: " + String(self.user.rate)
            self.ViewNumberRateLabel.text =  String(self.user.numRate) + " rates"
            
            
            var courses : String = ""
            for item in self.user.courseTaken{
                courses = courses + item + " "
            }
            self.ViewCoursesTakenLabel.text = courses
            
        }
        imgUrl = self.user.url
        print("*********")
        print(imgUrl)
        if(imgUrl == ""){}
        else{
            imageData = try!Data(contentsOf: URL(string:imgUrl) ??  URL(fileURLWithPath: defaultProfile!))
            self.ViewPhotoImageView.image = UIImage(data : imageData)
        }
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        
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

extension ViewProfileViewController: ProfileDelegate {
    func didReceiveData(_ user: TutaUser) {
        self.user = user
        print("did receieve: " + self.user.description)
        ViewDescriptionTextView.text = self.user.description
        self.ViewPhoneNumberLabel.text = user.phone
        imgUrl = self.user.url
        if(imgUrl == ""){}
        else{
        imageData = try!Data(contentsOf: URL(string:imgUrl) ??  URL(fileURLWithPath: defaultProfile!))
        self.ViewPhotoImageView.image = UIImage(data : imageData)
        }
        self.ViewPhotoImageView.image = UIImage(data : imageData)
        self.ViewRatingLabel.text = "rating: " + String(self.user.rate)
        self.ViewNumberRateLabel.text =  String(self.user.numRate) + " rates"
        var courses : String = ""
        for item in self.user.courseTaken{
            courses = courses + item + " "
        }
        ViewCoursesTakenLabel.text = courses
//        print("did updated " + DescriptionText.text!)
    }

}

extension ViewProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

     func imagePickerController( _ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            ViewPhotoImageView.contentMode = .scaleAspectFit
            ViewPhotoImageView.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
         if ViewPhotoImageView.image != nil{
            dc.uploadProfilePic(img1: ViewPhotoImageView.image!, user: self.user){(url) in
                 self.imgUrl = (url)}
            print(self.imgUrl)
            print("upload a picture")
         }
    }
    
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}

/*从临时mepage移动来的 --LK*/
extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let mainBlue = UIColor.rgb(red: 0, green: 150, blue: 255)
}

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat? = 0,
                paddingLeft: CGFloat? = 0, paddingBottom: CGFloat? = 0, paddingRight: CGFloat? = 0, width: CGFloat? = nil, height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop!).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft!).isActive = true
        }
        
        if let bottom = bottom {
            if let paddingBottom = paddingBottom {
                bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
            }
        }
        
        if let right = right {
            if let paddingRight = paddingRight {
                rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
            }
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
