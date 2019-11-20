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
    
    func uploadUserToCloud(tutaUser : TutaUser)->Bool{
        let docRef = db.collection("users").document(tutaUser.uid)
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
    
    func uploadProfilePic(img1 :UIImage, user: TutaUser, completion: @escaping ((String) -> Void)){
        
        let uploadData = img1.jpegData(compressionQuality: 0.3)!
        //var data = NSData()
        //data = UIImageJPEGRepresentation(img1, 0.8)! as NSData
        // set upload path
        let filePath = "\(user.uid)" // path where you wanted to store img in storage
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        var downloadURL = ""
        let storageRef = Storage.storage().reference()
        let imageName = NSUUID().uuidString
        let storeImage = storageRef.child("Images").child(user.uid).child(imageName)
        var strURL = ""
        storeImage.putData(uploadData, metadata: metaData, completion: { (metaData, error) in
            storeImage.downloadURL(completion: { (url, error) in
                if let urlText = url?.absoluteString {

                    strURL = urlText
                    print(strURL)
                    //print("///////////tttttttt//////// \(strURL)   ////////")
                    user.url = strURL
                    self.uploadUserToCloud(tutaUser: user)
                    completion(strURL)
                }
            })
        })
    }
    
    func updateRate(uid: String, rate: Double){
        let docRef = db.collection("users").document(uid)
        docRef.getDocument{(document, error) in
            if let document = document, document.exists{
                var numRate = document.data()!["numRate"] as! Int
                let rate = ((document.data()!["rate"] as! Double) * Double(numRate) + rate) / Double(numRate+1)
                numRate = numRate + 1
                docRef.updateData(["rate": rate, "numRate": numRate])
                let postCards = document.data()!["postCards"] as! [String]
                for cardID in postCards{
                    let cardRef = self.db.collection("postCards").document(cardID)
                    cardRef.updateData(["rate": rate, "numRate": numRate])
                }
            }
        }
        
    }
    /**************************************************************************************/
    
    
    /*******************************FUNCTION FOR POSTCARD*********************************/
    
    func getNewCardID(type : String, course : String)->String{
        let cardID = Firestore.firestore().collection("postCard").document(type).collection(course).document().documentID
    Firestore.firestore().collection("postCard").document(type).collection(course).document(cardID).setData(["placeHolder":"just book this place"])
        return cardID
    }
    
    func getCardFromCloud(cardID : String, type: String, course : String, completion: @escaping ((PostCard) -> ())){
        
        let docRef = db.collection("postCards").document(type).collection(course).document(cardID)
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

    
    func getCardsCollection(type: String, course: String, completion: @escaping (([[String:Any]]) -> Void)) {
        var cards = [[String:Any]]()
        let ref = db.collection("postCards").document(type).collection(course)
        ref.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    cards.append(document.data())
                }
                completion(cards)
            }
        }
    }
    
    
    func uploadCardToCloud(postCard : PostCard)->Bool{
        let docRef = db.collection("postCards").document(postCard.type).collection(postCard.course).document(postCard.cardID)
        let userRef = db.collection("users").document(postCard.creatorID)
        docRef.setData(postCard.getCardData())
        userRef.updateData(["postCards": FieldValue.arrayUnion([postCard.cardID])])
        
        return true // needs to handle error and staff later
    }
    
    func getCardCollection(type: String, course: String, completion: @escaping ( ([PostCard])-> ())){
        var cardCollection = [PostCard]()
        let docRef = db.collection("postCards").document(type).collection(course)
        docRef.getDocuments(){(querySnapshot, err) in
            if let err = err{
                print ("error getting documents: \(err)")
            }
            else{
                for document in querySnapshot!.documents{
                    var cardObj = PostCard(value: document.data())
                    cardCollection.append(cardObj)
                }
            }
            completion(cardCollection)
        }
    }
    
    /**************************************************************************************/
    
    
    /*******************************FUNCTION FOR EVENTS*********************************/
    
    static func getNewEventID()->String{
        let eid = Firestore.firestore().collection("events").document().documentID
        Firestore.firestore().collection("events").document(eid).setData(["placeHolder":"just book this place"])
        return eid
    }
    
    func getEventFromCloud(at path: String, completion: @escaping ((Event) -> ())) {
        let ref = db.collection("events").document(path)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                //let dictionaries = snapshot?.documents.compactMap({$0.data()}) ?? []
                //let addresses = dictionaries.compactMap({Address($0)})
                let event = Event(value: document.data() ?? [String:Any]())
                completion(event)
            }
            else{
            }
        }
    }
    
    func uploadEventToCloud(event : Event)->Bool{
        let docRef = db.collection("events").document(event.eventID)
        let tutorRef = db.collection("users").document(event.tutorID)
        let studentRef = db.collection("users").document(event.studentID)
        docRef.setData(event.getEventData())
        tutorRef.updateData(["events": FieldValue.arrayUnion([event.eventID])])
        studentRef.updateData(["events": FieldValue.arrayUnion([event.eventID])])
        
        return true
    }
    
}
