//
//  tutaUser.swift
//  Tuta
//
//  Created by Mingyu Chen on 11/2/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import Foundation
import Firebase

class TutaUser{
    var name : String
    var email : String
    var url : String
    var gender : String
    var rating : Double
    var description: String
    var numRate : Int
    var courseTaken : [String]
    var phone : String
    var uid : String
    var events : [String]
    var postCards : [String]
    
    init(){
        self.name = ""
        self.email = ""
        self.url = ""
        self.gender = ""
        self.rating = 0
        self.description = ""
        self.numRate = 0
        self.courseTaken = [String]()
        self.phone = ""
        self.uid = ""
        self.events = [String]()
        self.postCards = [String]()
    }
    
    init(name:String, email:String, url:String, gender:String, rating:Double, description:String,
         numRate : Int, courseTaken : [String], phone : String, uid : String, events : [String], postCards: [String]){
        self.name = name
        self.email = email
        self.url = url
        self.gender = gender
        self.rating = rating
        self.description = description
        self.numRate = numRate
        self.courseTaken = courseTaken
        self.phone = phone
        self.uid = uid
        self.events = events
        self.postCards = postCards
    }
    
    init(value : [String: Any]){
        self.name = value["name"] as? String ?? ""
        self.email = value["email"] as? String ?? ""
        self.url = value["url"] as? String ?? ""
        self.gender = value["gender"] as? String ?? ""
        self.rating = value["rating"] as? Double ?? 0.0
        self.description = value["description"] as? String ?? ""
        self.numRate = value["numRate"] as? Int ?? 0
        self.courseTaken = value["courseTaken"] as? [String] ?? [String]()
        self.phone = value["phone"] as? String ?? ""
        self.uid = value["uid"] as? String ?? ""
        self.events = value["events"] as? [String] ?? [String]()
        self.postCards = value["postCards"] as? [String] ?? [String]()
    }
    
    func getUserData()-> [String: Any]{
        return[
            "name" : self.name,
            "email" : self.email,
            "url" : self.url,
            "gender" : self.gender,
            "rating" : self.rating,
            "description" : self.description,
            "numRate" : self.numRate,
            "courseTaken" : self.courseTaken,
            "phone" : self.phone,
            "uid" : self.uid,
            "events": self.events,
            "postCards": self.postCards
        ]
    }
    
}

