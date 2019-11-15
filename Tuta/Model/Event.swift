//
//  Event.swift
//  Tuta
//
//  Created by 陈明煜 on 11/13/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import Foundation

class Event{
    var eventID : String
    var studentID : String
    var tutorID : String
    var time : String
    var date : String
    var course : String
    var status : String
    
    init(){
        eventID = ""
        studentID = ""
        tutorID = ""
        time = ""
        date = ""
        course = ""
        status = ""
    }
    
    init(eventID: String, studentID: String, tutorID: String, time: String, date: String,
         course: String, status: String){
        self.eventID = eventID
        self.status = status
        self.studentID = studentID
        self.tutorID = tutorID
        self.date = date
        self.time = time
        self.course = course
    }
    
    init(value: [String: Any]){
        self.eventID = value["eventID"] as? String ?? DataController.getNewEventID()
        self.status = value["status"] as? String ?? ""
        self.studentID = value["studentID"] as? String ?? ""
        self.tutorID = value["tutorID"] as? String ?? ""
        self.date = value["date"] as? String ?? ""
        self.time = value["time"] as? String ?? ""
        self.course = value["course"] as? String ?? ""
    }
    
    func getEventData() -> [String: Any]{
        return [
            "eventID": self.eventID,
            "status": self.status,
            "studentID": self.studentID,
            "tutorID": self.tutorID,
            "date": self.date,
            "time": self.time,
            "coures": self.course
        ]
    }
    
}
