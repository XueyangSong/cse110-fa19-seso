//
//  ViewProfile.swift
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
    let dc = DataController()
    var user : TutaUser = TutaUser()
//    let userID = Auth.auth().currentUser?.uid

    var imgUrl = ""
    var imagePicker = UIImagePickerController()
    var imageData = Data()
    let defaultProfile = Bundle.main.path(forResource: "stu-1", ofType: "jpg")

    

}
