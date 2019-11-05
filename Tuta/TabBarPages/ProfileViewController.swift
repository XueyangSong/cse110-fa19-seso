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

class ProfileViewController: UIViewController {
    
    let dc = DataController()
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var rating: UILabel!
    
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var descriptionButton: UIButton!
    @IBOutlet weak var coursesTakenButton: UIButton!
    
    @IBAction func genderButtonPressed(_ sender: UIButton) {
    }
    @IBAction func nameButtonPressed(_ sender: UIButton) {
    }
    @IBAction func emailButtonPressed(_ sender: UIButton) {
    }
    @IBAction func descriptionButtonPressed(_ sender: UIButton) {
    }
    @IBAction func coursesTakenButtonPressed(_ sender: UIButton) {
    }
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        var user : TutaUser! = nil
        var x = 10
        super.viewDidLoad()
        let userID = Auth.auth().currentUser?.uid
        
        let docRef = db.collection("user").document(userID!)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let document = document
                if (document.exists){
                    
                   
                    user = TutaUser(value: document.data() ?? [String:Any]())
                    
                    self.nameButton.titleLabel?.text = user.name
                    self.emailButton.titleLabel?.text = user.email
                    self.genderButton.titleLabel?.text = user.gender ?? "drag queen"
                    self.descriptionButton.titleLabel?.text = user.description ?? "No description"
                    var courses : String = ""
                    for item in user.courseTaken{
                        courses = courses + item
                    }
                    
                    self.coursesTakenButton.titleLabel?.text = courses
                    
                }
            } else {
                print("Document does not exist")
            }
 
        }
        
        
 
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
