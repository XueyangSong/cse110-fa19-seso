//
//  ProfileViewController.swift
//  Tuta
//
//  Created by Zhen Duan on 11/2/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase



class ProfileViewController: UIViewController {
    let dc = DataController()
    var user : TutaUser = TutaUser()
    let userID = Auth.auth().currentUser?.uid
//    static var user : TutaUser = TutaUser()
    @IBOutlet weak var DescriptionTextView: UITextView!

    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
   

    @IBOutlet weak var rating: UILabel!
    
    
    @IBOutlet weak var CoursesTakenTextField: UITextField!
    
    @IBAction func genderButtonPressed(_ sender: UIButton) {
    }
    
    @IBOutlet weak var DescriptionEditButton: UIButton!
    
    @IBAction func EditDescription(_ sender: Any) {
/*        let sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "descriptionViewController") as DescriptionViewController
        vc.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(vc, animated: true, completion: nil)*/
    }
    
    @IBAction func CoursesTakenTextFieldChanged(_ sender: UITextField) {
       }
    
    let db = Firestore.firestore()
    
    var refreshControl = UIRefreshControl()

    @objc func refresh(sender:AnyObject) {
       // Code to refresh table view
    }
   
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        dc.delegate = self
        
        dc.getUserFromCloud(userID: self.userID!){(e) in self.user = (e)
            
            self.NameLabel.text = self.user.name
            self.EmailLabel.text = self.user.email
            self.genderLabel.text = self.user.gender
            
            self.DescriptionTextView.text = self.user.description
            var courses : String = ""
            for item in self.user.courseTaken{
                courses = courses + item
            }
            self.CoursesTakenTextField.text = courses
            
        }
        
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
 
    }
    
    func updateTextField(user: TutaUser){
        self.genderLabel.text = user.gender
        self.DescriptionTextView.text = user.description
        var courses : String = ""
        for item in user.courseTaken{
            courses = courses + item
        }
        self.CoursesTakenTextField.text = courses
        print("updated " + self.DescriptionTextView.text)
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
        DescriptionTextView.text = self.user.description
        genderLabel.text = self.user.description
        var courses : String = ""
        for item in self.user.courseTaken{
            courses = courses + item
        }
        CoursesTakenTextField.text = courses
        print("did updated " + DescriptionTextView.text)
    }
    
    
}
