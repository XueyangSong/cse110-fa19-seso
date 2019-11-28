//
//  EventListViewController.swift
//  Tuta
//
//  Created by Zhen Duan on 11/22/19.
//  Copyright © 2019 Zhen Duan. All rights reserved.
//

import UIKit
import Foundation
import FirebaseFirestore
import FirebaseAuth
import Firebase

private let reuseIdentifier = "EventListCell"


class EventListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    // tableView
    var tableView: UITableView!
    // events arrays
    var requestedEventsArray = [Event]()
    var inProgressEventsArray = [Event]()
    var finishedEventsArray = [Event]()
    // 2-D array
    var SectionArray = [
        ExpandableEventsArray(isExpanded: true, events: ["CSE 130 --- with David", "HILD 7A --- with Charlie", "MATH 20C --- with Nguyen", "ECON 100A -- with Eugene", "ECE 100 --- with Hector", "CSE 110 --- with Mathew", "CSE 190 --- Marcus"]),
        ExpandableEventsArray(isExpanded: true, events: ["MATH 189 --- with Zhen", "MATH 191 --- with Gary", "CHEM 6C --- with Leomart", "BILD 10 --- with Snow"]),
        ExpandableEventsArray(isExpanded: true, events: ["EDS 124BR --- with Jamie", "COGS 108 --- with Cersei"]),
//        ExpandableEventsArray(isExpanded: true, events: []),
//        ExpandableEventsArray(isExpanded: true, events: []),
//        ExpandableEventsArray(isExpanded: true, events: []),
    ]
    
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
//        fetchEvents()
    }
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        tableView.register(EventListCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.frame = view.frame
        
        tableView.tableFooterView = UIView()
    }
    
    func setUpUI() {
        configureTableView()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        navigationItem.title = "Settings"
    }
    
    
    // MARK: - Fetch data from server
    func fetchEvents() {
        
        // testing
        print("try to fetch data from cloud")
        var testName: String = "Null"
        
        // properties
        var eventIds = [String]()
        var eventArray = [Event]()
        var user : TutaUser = TutaUser()
        var event : Event = Event()

        // get event ids
        let dc = DataController()
        let userID = Auth.auth().currentUser?.uid
        dc.getUserFromCloud(userID: userID!) {(e) in user = (e)
            eventIds = user.events
            testName = user.name
            print("This is in getUser. Name is: " + testName)
            
            // get events
            for eventId in eventIds {
                dc.getEventFromCloud(at: eventId) {(e) in event = (e)
                    eventArray.append(event)
                    print(event.course)
                }
            }
            
            let secondsToDelay = 2.0
            DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                //print("This message is delayed")
                // Put any code you want to be delayed here
                
                
                // put events into eventArrays
                for event in eventArray {
                    if event.status == "requested" {
                        self.requestedEventsArray.append(event)
                    }
                    else if event.status == "inProgress" {
                        self.inProgressEventsArray.append(event)
                    }
                    else if event.status == "finished" {
                        self.finishedEventsArray.append(event)
                    }
                    else {
                        print("Error: event status wrong!")
                    }
                }
                
                // update the 2-d array
                var tempString: String!
                for event in self.requestedEventsArray {
                    tempString = self.eventToString(event: event)
                    self.SectionArray[0].events.append(tempString)
                }
                for event in self.inProgressEventsArray {
                    tempString = self.eventToString(event: event)
                    self.SectionArray[1].events.append(tempString)
                }
                for event in self.finishedEventsArray {
                    tempString = self.eventToString(event: event)
                    self.SectionArray[2].events.append(tempString)
                }
                print(self.SectionArray[0].events)
            }
            
            
            
        }
        print("This is outside getUser. Name is: " + testName)
        
        
        print(SectionArray[0].events)

        
        
    }
    
    func eventToString(event: Event) -> String {
        
        // properties
        let courseName = "[" + event.course + "] "
        let studentId = event.studentID
        let tutorId = event.tutorID
        var studentName: String!
        var tutorName: String!
        
        let dc = DataController()
        var user : TutaUser = TutaUser()
//        // get student name
//        dc.getUserFromCloud(userID: studentId) {(e) in user = (e)
//            studentName = "std: " + user.name + "; "
//        }
//        // get tutor name
//        dc.getUserFromCloud(userID: tutorId) {(e) in user = (e)
//            tutorName = "tutor: " + user.name
//        }
        
//        var toString: String!
//        let secondsToDelay = 2.0
//        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
//            toString = courseName + studentName + tutorName
//            print("eventToString is Called!")
//            print(toString!)
//        }
//        sleep(2)
//        return toString
        return courseName
    }

    
    // MARK: - TableView Configurations
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return EventListSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !SectionArray[section].isExpanded {
            return 0
        }
        
        return SectionArray[section].events.count

        
//        guard let section = EventListSection(rawValue: section) else { return 0 }
//
//        switch section {
//        case .requested: return 5 //SocialOptions.allCases.count
//        case .inProgress: return 5 //CommunicationOptions.allCases.count
//        case .finished: return 5
//        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // build view
        let view = UIView()
        view.backgroundColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        
        // build button
        let button = UIButton(type: .system)
        view.addSubview(button)
        button.setTitle("close", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.tag = section
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        let screenSize = UIScreen.main.bounds
        button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenSize.width-50).isActive = true
        
        // build Label
        let title = UILabel()
        view.addSubview(title)
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .white
        title.text = EventListSection(rawValue: section)?.description
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true

        return view
    }
    
    @objc func handleExpandClose(button: UIButton) {
        print("Trying to expand and close section...")
        
        let section = button.tag
        
        // we'll try to close the section first by deleting the rows
        var indexPaths = [IndexPath]()
        for row in SectionArray[section].events.indices {
            print(0, row)
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = SectionArray[section].isExpanded
        SectionArray[section].isExpanded = !isExpanded
        
        button.setTitle(isExpanded ? "open" : "close", for: .normal)
        
        if isExpanded {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let event = SectionArray[indexPath.section].events[indexPath.row]
        
        cell.textLabel?.text = event
        
        return cell
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EventListCell
//        guard let section = EventListSection(rawValue: indexPath.section) else { return UITableViewCell() }
//
//        switch section {
//        case .requested:
//            let type = "requested"
//            print(type)
//            //get cells
//            // color
//        case .inProgress:
//            let type = "inProgress"
//            print(type)
//            // color
//        case .finished:
//            let type = "finished"
//            print(type)
//            // set color
//        }
//
//        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")

            // remove event from the array and the database
            //self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row: ")
        print(indexPath)
        
        let cell = tableView.cellForRow(at: indexPath)
        //let rateViewController = RateViewController(eventID: "string")
        //navigationController?.pushViewController(UIViewController(), animated: true)
        self.performSegue(withIdentifier: "navToRatePage", sender: cell)
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Find the selected event
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let event = finishedEventsArray[indexPath.row]
        let eventID = event.eventID
        print("Selected event ID is >>>>>>>>>>>>>>>>>>> " + eventID)
        
        // Pass the eventID to the rate view controller
        let rateViewController = segue.destination as! RateViewController
        rateViewController.eventID = eventID
    }*/
}
