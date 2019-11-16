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
    var username : String
    var userID : String
    var course :  String
    var type : String
    var numOfRatings: String
    var rating: String
    
    init(){
        self.cardID = "no card ID"
        self.description = ""
        self.date = "2000-01-01"
        self.time = "0:00:00 AM"
        self.userID = ""
        self.username = ""
        self.course = ""
        self.type = ""
        self.rating = "0.0"
        self.numOfRatings = "0"
    }
    
    init(userID : String, username: String, description : String, date : String, time : String, cardID : String, course : String, type : String, rating: String, numOfRatings: String){
        self.cardID = cardID
        self.description = description
        self.date = date
        self.time = time
        self.userID = userID
        self.username = username
        self.course = course
        self.type = type
        self.rating = rating
        self.numOfRatings = numOfRatings
    }
    
    init(value : Dictionary<String, Any>){
        self.description = value["description"] as? String ?? ""
        self.date = value["date"] as? String ?? ""
        self.time = value["time"] as? String ?? ""
        self.userID = value["userID"] as? String ?? ""
        self.username = value["username"] as? String ?? ""
        self.course = value["course"] as? String ?? ""
        self.type = value["type"] as? String ?? ""
        self.cardID = value["cardID"] as? String ?? ""
        self.rating = value["rating"] as? String ?? ""
        self.numOfRatings = value["numOfRatings"] as? String ?? ""
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
            "userID" : self.userID,
            "username": self.username,
            "course" : self.course,
            "type" : self.type,
            "rating" : self.rating,
            "numOfRatings": self.numOfRatings
        ]
    }
    
    
}
