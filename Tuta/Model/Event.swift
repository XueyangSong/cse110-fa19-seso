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
    var studentName : String
    var tutorName : String
    var requesterID : String
    
    init(){
        eventID = ""
        studentID = ""
        tutorID = ""
        time = ""
        date = ""
        course = ""
        status = ""
        studentName = ""
        tutorName = ""
        requesterID = ""
    }
    
    init(studentID: String, tutorID: String, time: String, date: String,
         course: String, status: String, studentName: String, tutorName: String, requesterID: String){
        self.eventID = DataController.getNewEventID()
        self.status = status
        self.studentID = studentID
        self.tutorID = tutorID
        self.date = date
        self.time = time
        self.course = course
        self.studentName = studentName
        self.tutorName = tutorName
        self.requesterID = requesterID
    }
    
    init(value: [String: Any]){
        self.eventID = value["eventID"] as? String ?? DataController.getNewEventID()
        self.status = value["status"] as? String ?? ""
        self.studentID = value["studentID"] as? String ?? ""
        self.tutorID = value["tutorID"] as? String ?? ""
        self.date = value["date"] as? String ?? ""
        self.time = value["time"] as? String ?? ""
        self.course = value["course"] as? String ?? ""
        self.studentName = value["studentName"] as? String ?? ""
        self.tutorName = value["tutorName"] as? String ?? ""
        self.requesterID = value["requesterID"] as? String ?? ""
    }
    
    func getEventData() -> [String: Any]{
        return [
            "eventID": self.eventID,
            "status": self.status,
            "studentID": self.studentID,
            "tutorID": self.tutorID,
            "date": self.date,
            "time": self.time,
            "course": self.course,
            "tutorName": self.tutorName,
            "studentName": self.studentName,
            "requesterID": self.requesterID
        ]
    }
    
    func getOtherPersonId() -> String {
        return requesterID
    }
    
    
    func eventToString(uid: String) -> String {
        if (self.status == "requested"){
            if (uid == self.requesterID){
                if (uid == self.studentID){
                    return "\(self.course): Requested \(self.tutorName) to be your tutor"
                }
                else{
                    return "\(self.course): Requested \(self.studentName) to be your student"
                }
            }
            else{
                if (uid == self.studentID){
                    return "\(self.course): \(self.tutorName) wants to be your tutor"
                }
                else{
                    return "\(self.course): \(self.studentName) wants to be your student"
                }
            }
        }
        else{
            if (uid == self.studentID){
                return "\(self.course) with tutor \(self.tutorName)"
            }
            else{
                return "\(self.course) with student \(self.studentName)"
            }
        }
    }
    
}
