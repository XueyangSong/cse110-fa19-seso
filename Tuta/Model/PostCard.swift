//
//  PostCard.swift
//  Tuta
//
//  Created by Mingyu Chen on 11/4/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import Foundation

class PostCard{
    var cardID : String
    var description : String
    var date : String
    var time : String
    var creatorID : String
    var creatorName : String
    var course :  String
    var type : String
    var rate : Double
    var numRate : Int
    
    init(){
        self.cardID = "no card ID"
        self.description = ""
        self.date = "2000-01-01"
        self.time = "0:00:00 AM"
        self.creatorID = ""
        self.course = ""
        self.type = ""
        self.rate = 0.0
        self.numRate = 0
        self.creatorName = ""
    }
    
    init(creator : String, description : String, date : String,
         time : String, cardID : String, course : String, type : String, rate: Double, numRate: Int,
         creatorName: String){
        self.cardID = cardID
        self.description = description
        self.date = date
        self.time = time
        self.creatorID = creator
        self.course = course
        self.type = type
        self.rate = rate
        self.numRate = numRate
        self.creatorName = creatorName
    }
    
    init(value : Dictionary<String, Any>){
        self.description = value["description"] as? String ?? ""
        self.date = value["date"] as? String ?? ""
        self.time = value["time"] as? String ?? ""
        self.creatorID = value["creatorID"] as? String ?? ""
        self.course = value["course"] as? String ?? ""
        self.type = value["type"] as? String ?? ""
        self.cardID = value["cardID"] as? String ?? ""
        self.rate = value["rate"] as? Double ?? 0.0
        self.numRate = value["numRate"] as? Int ?? 0
        self.creatorName = value["creatorName"] as? String ?? ""
    }
    /*
    func setUpCardID(){
        self.cardID = DataController.getNewCardID(type: self.type, course: self.course)
    }
    */
    func getCardData() -> Dictionary<String, Any>{
        return [
            "cardId" : self.cardID,
            "description" : self.description,
            "date" : self.date,
            "time" : self.time,
            "creatorID" : self.creatorID,
            "course" : self.course,
            "type" : self.type,
            "rate": self.rate,
            "numRate": self.numRate,
            "creatorName": self.creatorName
        ]
    }
    
    
}
