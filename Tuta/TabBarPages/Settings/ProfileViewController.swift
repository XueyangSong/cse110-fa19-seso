//
//  ProfileViewController.swift
//  Tuta
//
//  Created by Alex Li on 11/2/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase



class ProfileViewController: UIViewController{
    let dc = DataController()
    var user : TutaUser = TutaUser()
    let userID = Auth.auth().currentUser?.uid

    var imgUrl = ""
    var imagePicker = UIImagePickerController()
    var imageData = Data()
    let defaultProfile = Bundle.main.path(forResource: "stu-1", ofType: "jpg")
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "backIcon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(getBack), for: .touchUpInside)
        return button
    }()
    
    @IBOutlet weak var avatar: UIButton!
    @IBOutlet weak var DescriptionText: UITextField!
    
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var EmailLabel: UILabel!
    
    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    @IBOutlet weak var numberRate: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!

    @IBAction func uploadAvatar(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBOutlet weak var rating: UILabel!
    
    @IBOutlet weak var CoursesTakenTextField: UITextField!
    
    @IBAction func CoursesTakenTextFieldChanged(_ sender: UITextField) {
       }
    
    let db = Firestore.firestore()
    
    var refreshControl = UIRefreshControl()

    @objc func refresh(sender:AnyObject) {
       // Code to refresh table view
    }
    
    @objc func getBack() {
        let sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "MyProfileViewController") as MyProfileViewController
        vc.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(vc, animated: true, completion: nil)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Work!")
        avatar.apply()

        dc.delegate = self
        dc.getUserFromCloud(userID: self.userID!){(e) in self.user = (e)
            
            self.NameLabel.text = self.user.name
            self.EmailLabel.text = self.user.email
            self.genderLabel.text = self.user.gender
            self.phoneLabel.text = self.user.phone
            self.DescriptionText.text = self.user.description
            self.rating.text = "rating: " + String(self.user.rating)
            self.numberRate.text =  String(self.user.numRate) + " rates"
            
            
            var courses : String = ""
            for item in self.user.courseTaken{
                courses = courses + item + " "
            }
            self.CoursesTakenTextField.text = courses
            
        }
        imgUrl = self.user.url
        if(imgUrl == ""){}
        else{
        imageData = try!Data(contentsOf: URL(string:imgUrl) ??  URL(fileURLWithPath: defaultProfile!))
        self.profilePictureImageView.image = UIImage(data : imageData)
        }
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        self.view.addSubview(backButton)
        backButton.anchor(top: self.view.topAnchor, left: self.view.leftAnchor,
                          paddingTop: 48, paddingLeft: 16, width: 32, height: 32)

        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    func updateTextField(user: TutaUser){
        self.DescriptionText.text = user.description
        self.phoneLabel.text = user.phone
        imgUrl = self.user.url
        if(imgUrl == ""){}
        else{
        imageData = try!Data(contentsOf: URL(string:imgUrl) ??  URL(fileURLWithPath: defaultProfile!))
        self.profilePictureImageView.image = UIImage(data : imageData)
        }
        self.profilePictureImageView.image = UIImage(data : imageData)
        var courses : String = ""
        for item in user.courseTaken{
            courses = courses + item
        }
        self.CoursesTakenTextField.text = courses
        print("updated " + self.DescriptionText.text!)
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

extension ProfileViewController: ProfileDelegate {
   
    
    func didReceiveData(_ user: TutaUser) {
        self.user = user
        print("did receieve: " + self.user.description)
        DescriptionText.text = self.user.description
        self.phoneLabel.text = user.phone
        imgUrl = self.user.url
        if(imgUrl == ""){}
        else{
        imageData = try!Data(contentsOf: URL(string:imgUrl) ??  URL(fileURLWithPath: defaultProfile!))
        self.profilePictureImageView.image = UIImage(data : imageData)
        }
        self.profilePictureImageView.image = UIImage(data : imageData)
        self.rating.text = "rating: " + String(self.user.rating)
        self.numberRate.text =  String(self.user.numRate) + " rates"
        var courses : String = ""
        for item in self.user.courseTaken{
            courses = courses + item + " "
        }
        CoursesTakenTextField.text = courses
        print("did updated " + DescriptionText.text!)
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

     func imagePickerController( _ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profilePictureImageView.contentMode = .scaleAspectFit
            profilePictureImageView.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
         if profilePictureImageView.image != nil{
            dc.uploadProfilePic(img1: profilePictureImageView.image!, user: self.user){(url) in
                 self.imgUrl = (url)}
            print(self.imgUrl)
            print("upload a picture")

         }
    }
    
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
