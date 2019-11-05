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
        var user : tutaUser! = nil
        super.viewDidLoad()
        let userID = Auth.auth().currentUser?.uid
        //print(userID)
        
        let docRef = db.collection("user").document(userID!)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let document = document
                if (document.exists){
                    let name = document.get("name")!
                    let email = document.get("email")!
                    let gender = document.get("gender")!
                    let description = document.get("description")
                    let rate = document.get("rate")
                    let picture = document.get("picture")
                    print("\(name)")
                    user = tutaUser(name: "\(name)", email: "\(email)", url: "\(picture)", gender: "\(gender)", rate: "\(rate)", description: "\(description)")
                    
                    self.nameButton.titleLabel?.text = user.name
                    self.emailButton.titleLabel?.text = user.email
                    self.genderButton.titleLabel?.text = user.gender ?? "drag queen"
                    self.descriptionButton.titleLabel?.text = user.description ?? "No description"
                    
                    
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
