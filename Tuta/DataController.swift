//
//  DataController.swift
//  Tuta
//
//  Created by 陈明煜 on 11/4/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseStorage

class DataController{
    
    let db = Firestore.firestore()
    var uid = "uid"
    
    
    func getUserFromCloud(userID : String, completion: @escaping ((TutaUser) -> ())){
        
        let docRef = db.collection("user").document(userID)
        var userObj = TutaUser()
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                    //print(document.get("eventName") as! String)
                print("data get fetched")
                userObj = TutaUser(value: document.data() ?? [String:Any]())
                completion(userObj)
                    
            
            } else {
                print("Document does not exist")
            }
        }
        
    }
    
    func uploadUserToCloud(tutaUser : TutaUser, userId : String)->Bool{
        let docRef = db.collection("user").document(userId)
        docRef.setData(tutaUser.getUserData())
        return true
    }
    
    func getDownloadURL(path:String)->String{
        let storageRef = Storage.storage().reference()
        var downloadURL = ""
        storageRef.child(path).downloadURL { url, error in
          if let error = error {
            // Handle any errors
            downloadURL = "get url failed"
            print("get url failed")
          } else {
            // Get the download URL for 'images/stars.jpg'
            downloadURL = url?.absoluteString ?? "failed converting url"
            }
        }
        if downloadURL == ""{
            //wait for upload
            print("url didnt get")
        }
        return downloadURL
    }
    
    func uploadProfilePic(img1 :UIImage, userID:String,completion: @escaping ((String) -> Void)){
        
        let uploadData = img1.jpegData(compressionQuality: 0.3)!
        //var data = NSData()
        //data = UIImageJPEGRepresentation(img1, 0.8)! as NSData
        // set upload path
        let filePath = "\(userID)" // path where you wanted to store img in storage
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        var downloadURL = ""
        let storageRef = Storage.storage().reference()
        let imageName = NSUUID().uuidString
        let storeImage = storageRef.child("Images").child(userID).child(imageName)
        var strURL = ""
        storeImage.putData(uploadData, metadata: metaData, completion: { (metaData, error) in
            storeImage.downloadURL(completion: { (url, error) in
                if let urlText = url?.absoluteString {

                    strURL = urlText
                    print(strURL)
                    //print("///////////tttttttt//////// \(strURL)   ////////")

                    completion(strURL)
                }
            })
        })
    }
    
}
