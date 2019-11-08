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
//    static var user : TutaUser = TutaUser()
    @IBOutlet weak var DescriptionTextView: UITextView!

    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var genderButton: UIButton!

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
        let userID = Auth.auth().currentUser?.uid
        
        var user : TutaUser = TutaUser()
        dc.getUserFromCloud(userID: userID!){(e) in user = (e)
            
            self.NameLabel.text = user.name
            self.EmailLabel.text = user.email
            self.genderButton.titleLabel?.text = user.gender ?? "drag queen"
//            self.DescriptionTextField.text = user.description ?? "No description"
            
            self.DescriptionTextView.text = user.description ?? "please write down your description"
            var courses : String = ""
            for item in user.courseTaken{
                courses = courses + item
            }
            self.CoursesTakenTextField.text = courses ?? "No course taken"
            
        }
        
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
 
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
