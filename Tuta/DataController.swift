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
    
    func updateRating(uid: String, rating: Double){
        let docRef = db.collection("users").document(uid)
        docRef.getDocument{(document, error) in
            if let document = document, document.exists{
                var numRate = document.data()!["numRate"] as! Int
                let rating = ((document.data()!["rating"] as! Double) * Double(numRate) + rating) / Double(numRate+1)
                numRate = numRate + 1
                docRef.updateData(["rating": rating, "numRate": numRate])
                let postCards = document.data()!["postCards"] as! [String]
                for cardInfo in postCards{
                    let strArray = cardInfo.components(separatedBy: ",")
                    let cardRef = self.db.collection("postCards").document(strArray[1]).collection(strArray[2]).document(strArray[0])
                    cardRef.updateData(["rating": rating, "numRate": numRate])
                }
            }
        }
        
    }
    /**************************************************************************************/
    
    
    /*******************************FUNCTION FOR POSTCARD*********************************/
    
    func getNewCardID(type : String, course : String)->String{
        let cardID = Firestore.firestore().collection("postCards").document(type).collection(course).document().documentID
    //Firestore.firestore().collection("postCards").document(type).collection(course).document(cardID).setData(["placeHolder":"just book this place"])
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
        let ref = db.collection("postCards").document(type).collection(course).order(by: "rating", descending: true)
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
    
    
    
    func uploadCardToCloud(postCard : PostCard, completion: @escaping ((Bool) -> ())){
        let path = db.collection("postCards").document(postCard.type).collection(postCard.course)
        path.whereField("creatorID", isEqualTo: postCard.creatorID).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if querySnapshot?.documents.count != 0{
                       completion(false)
                    }
                    else{
                        let docRef = path.document(postCard.cardID)
                        let userRef = self.db.collection("users").document(postCard.creatorID)
                        docRef.setData(postCard.getCardData())
                        userRef.updateData(["postCards": FieldValue.arrayUnion([postCard.cardID + "," + postCard.type + "," + postCard.course])])
                        completion(true)
                    }
                }
        }
       // return true
    }
    
    func deletePostCard(cardDic: [String: Any]){
        db.collection("postCards").document(cardDic["type"] as! String)
            .collection(cardDic["course"] as! String).document(cardDic["cardID"] as! String).delete(){
                err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Post card Document successfully removed!")
                }
        }
        let cardID = cardDic["cardID"] as! String
        var docRef = db.collection("users").document(cardDic["creatorID"] as! String)
        var cardInfo = cardID + "," + (cardDic["type"] as! String) + "," + (cardDic["course"] as! String)
        docRef.updateData([
            "postCards": FieldValue.arrayRemove([cardInfo])
        ]){
            err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Post array element successfully updated")
            }
        }
    }
    
    /**************************************************************************************/
    
    
    /*******************************FUNCTION FOR EVENTS*********************************/
    
    static func getNewEventID()->String{
        let eid = Firestore.firestore().collection("events").document().documentID
      //  Firestore.firestore().collection("events").document(eid).setData(["placeHolder":"just book this place"])
        return eid
    }
   
    
    func ifRequestedBefore(event: Event, completion: @escaping ((Bool)->())){
        let docRef = db.collection("events")
        docRef.whereField("tutorID", isEqualTo: event.tutorID).whereField("studentID", isEqualTo: event.studentID).whereField("course", isEqualTo: event.course).getDocuments(){
            (querySnapshot, err) in
            if let err = err{
                print("Error getting documents: \(err) in isRequested")
                //completion(true)
            } else{
                if querySnapshot?.documents.count != 0{
                   completion(true)
                }
                else{
                    completion(false)
                }
            }
        }
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
    
    func getEventsListFromCloud(userID: String, completion: @escaping (([Event])->())){
        let docRef = db.collection("events")
        var eventList = [Event]()
        docRef.whereField("studentID", isEqualTo: userID).getDocuments(){
            (studentQuery, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }else{
                for document in studentQuery!.documents{
                    let event = Event(value: document.data())
                    eventList.append(event)
                }
            }
            docRef.whereField("tutorID", isEqualTo: userID).getDocuments(){
                (tutorQuery, error) in
                if let error = error{
                    print("Error getting documents: \(error)")
                } else{
                    for document in tutorQuery!.documents{
                        let event = Event(value: document.data())
                        eventList.append(event)
                    }
                }
                completion(eventList)
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
    
    func deleteEvent(event: Event){
        db.collection("events").document(event.eventID).delete(){
                err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Event Document successfully removed!")
                }
        }
        
        let tutorRef = db.collection("users").document(event.tutorID)
        tutorRef.updateData([
            "events": FieldValue.arrayRemove([event.eventID])
        ]){
            err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Tutor event array element successfully updated")
            }
        }
        let studentRef = db.collection("users").document(event.studentID)
        studentRef.updateData([
            "events": FieldValue.arrayRemove([event.eventID])
        ]){
            err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Student event array element successfully updated")
            }
        }
    }
    
    
    func updateEventStatus(event : Event, completion: @escaping ((Bool) -> ())){
        let docRef = db.collection("events").document(event.eventID)
        if event.status == "requested"{
            event.status = "inProgress"
        }
        else{
            event.status = "finished"
        }
        docRef.updateData(["status": event.status])
        completion(true)
    }
    
}
