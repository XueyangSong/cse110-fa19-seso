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
    var creatorName : String
    var creatorID : String
    var course :  String
    var type : String
    var numRate: Int
    var rating: Double
    var creatorURL: String

    
    init(){
        self.cardID = "no card ID"
        self.description = ""
        self.date = "2000-01-01"
        self.time = "0:00:00 AM"
        self.creatorID = ""
        self.creatorName = ""
        self.course = ""
        self.type = ""
        self.rating = 0.0
        self.numRate = 0
        self.creatorURL = ""

    }
    
    init(creatorID : String, creatorName: String, description : String, date : String, time : String, 
         cardID : String, course : String, type : String, rating: Double, numRate: Int, creatorURL: String){

        self.cardID = cardID
        self.description = description
        self.date = date
        self.time = time
        self.creatorID = creatorID
        self.creatorName = creatorName
        self.course = course
        self.type = type
        self.rating = rating
        self.numRate = numRate
        self.creatorURL = creatorURL
    }
    
    init(value : Dictionary<String, Any>){
        self.description = value["description"] as? String ?? ""
        self.date = value["date"] as? String ?? ""
        self.time = value["time"] as? String ?? ""
        self.creatorID = value["creatorID"] as? String ?? ""
        self.creatorName = value["creatorName"] as? String ?? ""
        self.course = value["course"] as? String ?? ""
        self.type = value["type"] as? String ?? ""
        self.cardID = value["cardID"] as? String ?? ""
        self.rating = value["rating"] as? Double ?? 0.0
        self.numRate = value["numRate"] as? Int ?? 0
        self.creatorURL = value["creatorURL"] as? String ?? ""
        
        // Round the rate to the first decimal place
        self.rating = Double(round(10 * self.rating) / 10)
    }
    /*
    func setUpCardID(){
        self.cardID = DataController.getNewCardID(type: self.type, course: self.course)
    }
    */
    func getCardData() -> Dictionary<String, Any>{
        return [
            "cardID" : self.cardID,
            "description" : self.description,
            "date" : self.date,
            "time" : self.time,
            "creatorID" : self.creatorID,
            "creatorName": self.creatorName,
            "course" : self.course,
            "type" : self.type,
            "rating" : self.rating,
            "numRate": self.numRate,
            "creatorURL": self.creatorURL

        ]
    }
    
    
}
