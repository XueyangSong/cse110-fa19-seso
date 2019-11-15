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
    var rate : Int
    var description: String
    var numRate : Int
    var courseTaken : [String]
    var phone : String
    var uid : String
    var events : [String]
    
    init(){
        self.name = ""
        self.email = ""
        self.url = ""
        self.gender = ""
        self.rate = 0
        self.description = ""
        self.numRate = 0
        self.courseTaken = [String]()
        self.phone = ""
        self.uid = ""
        self.events = [String]()
    }
    
    init(name:String, email:String, url:String, gender:String, rate:Int, description:String,
         numRate : Int, courseTaken : [String], phone : String, uid : String, events : [String]){
        self.name = name
        self.email = email
        self.url = url
        self.gender = gender
        self.rate = rate
        self.description = description
        self.numRate = numRate
        self.courseTaken = courseTaken
        self.phone = phone
        self.uid = uid
        self.events = events
    }
    
    init(value : [String: Any]){
        self.name = value["name"] as? String ?? ""
        self.email = value["email"] as? String ?? ""
        self.url = value["url"] as? String ?? ""
        self.gender = value["gender"] as? String ?? ""
        self.rate = value["rate"] as? Int ?? 0
        self.description = value["description"] as? String ?? ""
        self.numRate = value["numRate"] as? Int ?? 0
        self.courseTaken = value["courseTaken"] as? [String] ?? [String]()
        self.phone = value["phone"] as? String ?? ""
        self.uid = value["uid"] as? String ?? ""
        self.events = value["events"] as? [String] ?? [String]()
    }
    
    func getUserData()-> [String: Any]{
        return[
            "name" : self.name,
            "email" : self.email,
            "url" : self.url,
            "gender" : self.gender,
            "rate" : self.rate,
            "description" : self.description,
            "numRate" : self.numRate,
            "courseTaken" : self.courseTaken,
            "phone" : self.phone,
            "uid" : self.uid,
            "events": self.events
        ]
    }
    
}

