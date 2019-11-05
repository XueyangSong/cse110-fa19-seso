//
//  PostCard.swift
//  Tuta
//
//  Created by Mingyu Chen on 11/4/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import Foundation

class postCard{
    var cardID : String
    var description : String
    var date : String
    var time : String
    var creator : String
    var course :  String
    
    init(){
        self.cardID = "no card ID"
        self.description = ""
        self.date = "2000-01-01"
        self.time = "0:00:00 AM"
        self.creator = ""
        self.course = ""
    }
    
    init(creator : String, description : String, date : String,
         time : String, cardID : String, course : String){
        self.cardID = cardID
        self.description = description
        self.date = date
        self.time = time
        self.creator = creator
        self.course = course
    }
    
    init(value : Dictionary<String, Any>){
        self.cardID = value["cardID"] as? String ?? ""
        self.description = value["description"] as? String ?? ""
        self.date = value["date"] as? String ?? ""
        self.time = value["time"] as? String ?? ""
        self.creator = value["creator"] as? String ?? ""
        self.course = value["course"] as? String ?? ""
    }
    
    func getEventData() -> Dictionary<String, Any>{
        return [
            "cardId" : self.cardID,
            "description" : self.description,
            "date" : self.date,
            "time" : self.time,
            "creator" : self.creator,
            "course" : self.course
        ]
    }
    
    
}
