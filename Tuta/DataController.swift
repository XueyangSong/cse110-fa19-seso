//
//  DataController.swift
//  Tuta
//
//  Created by Mingyu Chen on 11/4/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseStorage

class DataController{
    
    weak var delegate: ProfileDelegate?
    let db = Firestore.firestore()
    var flag : Bool
    
    init(){
        self.flag = true
    }
    
    /******************************FUNCTION FOR USER***********************************/
    func getUserFromCloud(userID : String, completion : @escaping ((TutaUser)->())){
        
        let docRef = db.collection("users").document(userID)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                    //print(document.get("eventName") as! String)
             let user = TutaUser(value: document.data() ?? [String: Any]())
             self.delegate?.didReceiveData(user)
             completion(user)
            
            } else {
                print("Document does not exist")
            }
        }
        
    }
    
    func uploadUserToCloud(tutaUser : TutaUser, userId : String)->Bool{
        let docRef = db.collection("users").document(userId)
        docRef.setData(tutaUser.getUserData())
        return true
    }
    
    func getDownloadURL(uid: String, user: TutaUser)->String{
        let storageRef = Storage.storage().reference()
        var downloadURL = ""
        storageRef.child("Images").child(uid).child(user.url).downloadURL { url, error in
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
    
    func uploadProfilePic(img1 :UIImage, user: TutaUser, userID:String,completion: @escaping ((String) -> Void)){
        
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
                    user.url = strURL
                    self.uploadUserToCloud(tutaUser: user, userId: userID)
                    completion(strURL)
                }
            })
        })

    }
    
    /**************************************************************************************/
    
    
    /*******************************FUNCTION FOR POSTCARD*********************************/
    
    static func getNewCardID(type : String, course : String)->String{
        let cardID = Firestore.firestore().collection("postCard").document(type).collection(course).document().documentID
    Firestore.firestore().collection("postCard").document(type).collection(course).document(cardID).setData(["placeHolder":"just book this place"])
        return cardID
    }
    
    func getCardFromCloud(cardID : String, type: String, course : String, completion: @escaping ((PostCard) -> ())){
        
        let docRef = db.collection("postCard").document(type).collection(course).document(cardID)
        //var cardObj = PostCard()
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                    //print(document.get("eventName") as! String)
                print("data get fetched")
                let cardObj = PostCard(value: document.data() ?? [String:Any]())
                completion(cardObj)
                    
            
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func uploadCardToCloud(postCard : PostCard)->Bool{
        let docRef = db.collection("postCard").document(postCard.type).collection(postCard.course).document(postCard.cardID)
        
        docRef.setData(postCard.getCardData())
        
        return true // needs to handle error and staff later
    }
    
}
