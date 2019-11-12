//
//  DescriptionView.swift
//  Tuta
//
//  Created by Alex Li on 11/6/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase


class DescriptionViewController:UIViewController{
    
    let dc = DataController()
    let userID = Auth.auth().currentUser?.uid
    var user : TutaUser = TutaUser()
    
    @IBOutlet weak var DescriptionTextView: UITextView!
    

    @IBAction func BackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let userID = Auth.auth().currentUser?.uid
        DescriptionTextView.delegate = self
        DescriptionTextView.sizeThatFits(CGSize(width: DescriptionTextView.frame.size.width, height: DescriptionTextView.frame.size.height))
//        print(type(of: DescriptionTextView))
//        print(type(of: self))
        //DescriptionButton.backgroundColor = ;
    }

    @IBAction func EnterTapped(_ sender: Any) {
//        let userID = Auth.auth().currentUser?.uid
        
        dc.getUserFromCloud(userID: userID!){(e) in self.user = (e)
            self.user.description = self.DescriptionTextView.text!
            self.dc.uploadUserToCloud(tutaUser: self.user)
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        DescriptionTextView.resignFirstResponder()
    }
}

extension DescriptionViewController : UITextViewDelegate{
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
}

